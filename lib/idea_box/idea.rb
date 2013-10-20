 require 'time'

 class Idea
  include Comparable

  attr_reader :id, :title, :description, :rank, :tags, :created_at, :updated_at, :revision, :portfolio_id, :resources

  def initialize(attributes={})
    attributes = default_idea.merge(attributes)
    @id           = attributes["id"]
    @title        = attributes["title"]
    @description  = attributes["description"]
    @rank         = attributes["rank"]
    @tags         = attributes["tags"]
    @created_at   = attributes["created_at"]
    @updated_at   = attributes["updated_at"]
    @revision     = attributes["revision"]
    @portfolio_id = attributes["portfolio_id"]
    @resources    = attributes["resources"]
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
      "portfolio_id" => portfolio_id,
      "resources" => resources
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
      "created_at" => Time.now.to_s,
      "updated_at" => Time.now.to_s,
      "revision" => 1,
      "portfolio_id" => 1,
      "resources" => ['none']
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