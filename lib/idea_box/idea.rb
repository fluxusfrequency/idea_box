 require 'time'

 class Idea
  include Comparable

  attr_reader :title, :description, :rank, :id, :tags, :created_at, :updated_at, :revision, :group

  def initialize(attributes={})
    @id          = attributes["id"] || IdeaStore.all.last.id + 1
    @title       = attributes["title"] || 'New Idea'
    @description = attributes["description"] || 'My idea is...'
    @rank        = attributes["rank"] || 0
    @tags        = attributes["tags"] || 'unsorted'
    @created_at  = attributes["created_at"] || Time.now
    @updated_at  = attributes["updated_at"] || Time.now
    @revision    = attributes["revision"] || 1
    @group       = attributes["group"] || 'work'
  end

  def save
    IdeaStore.create(to_h)
  end

  def to_h
    { "id" => id,
      "title" => title,
      "description" => description,
      "rank" => rank,
      "tags" => tags,
      "created_at" => created_at,
      "updated_at" => updated_at,
      "revision" => revision,
      "group" => group.scan(/\w+/).first
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end

end