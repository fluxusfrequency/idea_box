 require 'time'

 class Idea
  include Comparable

  attr_reader :title, :description, :rank, :id, :tags, :created_at

  def initialize(attributes=default_attrs)
    @id          = attributes["id"]
    @title       = attributes["title"]
    @description = attributes["description"]
    @rank        = attributes["rank"] || 0
    @tags        = attributes["tags"]
    @created_at  = attributes["created_at"].to_time || Time.now.to_time
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
      "created_at" => created_at
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end

  def default_attrs
    { 'id' => 0,
      'title' => "New Idea",
      'description' => "This is my idea...",
      'rank' => 0,
      'tags' => 'unsorted',
      'created_at' => Time.now}
  end

end