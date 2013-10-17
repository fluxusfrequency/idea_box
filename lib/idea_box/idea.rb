 require 'time'

 class Idea
  include Comparable

  attr_reader :id, :title, :description, :rank, :tags, :created_at, :updated_at, :revision, :group

  def initialize(attributes={})
    attributes = default_idea.merge(attributes)
    @id          = attributes["id"]
    @title       = attributes["title"]
    @description = attributes["description"]
    @rank        = attributes["rank"]
    @tags        = attributes["tags"]
    @created_at  = attributes["created_at"]
    @updated_at  = attributes["updated_at"]
    @revision    = attributes["revision"]
    @group       = attributes["group"]
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

  def default_idea
    {
      "id" => next_id,
      "title" => 'New Idea',
      "description" => 'My Idea is...',
      "rank" => 0,
      "tags" => 'unsorted',
      "created_at" => Time.now.utc.to_s,
      "updated_at" => Time.now.utc.to_s,
      "revision" => 1,
      "group" => 'work'
    }
  end

  def next_id
    begin
      IdeaStore.size + 1
    rescue
      1
    end
  end

  def all_my_tags
    Array(tags.split(", "))
  end

end