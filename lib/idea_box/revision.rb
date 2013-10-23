 require 'time'

 class RevisedIdea
  include Comparable

  attr_reader :id, :idea_id, :title, :description, :tags, :rank, :uploads, :created_at, :updated_at, :resources

  def initialize(attributes={})
    attributes = default_revision.merge(attributes)
    @id          = attributes["id"]
    @idea_id     = attributes["idea_id"]
    @title       = attributes["title"]
    @description = attributes["description"]
    @tags        = attributes["tags"]
    @rank        = attributes["rank"]
    @uploads     = attributes["uploads"]
    @created_at  = attributes["created_at"]
    @updated_at  = attributes["updated_at"]
    @resources   = attributes["resources"]
  end

  def save
    RevisionStore.create(to_h)
  end

  def to_h
    { "id"          => id,
      "idea_id"     => idea_id,
      "title"       => title,
      "description" => description,
      "tags"        => tags,
      "rank"        => rank,
      "uploads"     => uploads,
      "created_at"  => created_at,
      "updated_at"  => updated_at,
      "resources"   => resources
    }
  end

  def default_revision
    {
      "id" => next_id,
      "idea_id" => 0,
      "title" => 'New Idea',
      "description" => 'My Idea is...',
      "tags" => 'unsorted',
      "rank"        => 0,
      "uploads"     => "none",
      "created_at"  => Time.now.to_s,
      "updated_at"  => Time.now.to_s,
      "resources"   => ['none']
    }
  end

  def next_id
    begin
      RevisionStore.size + 1
    rescue
      1
    end
  end

  def all_my_tags
    Array(tags.split(", "))
  end

  def revision
    RevisionStore.find_all_by_idea_id(idea_id).length
  end

end