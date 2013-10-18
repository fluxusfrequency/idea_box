require 'yaml/store'
require 'time'
# require './lib/idea_box/finders'
# require './lib/idea_box/groupers'
# require './lib/idea_box/sorters'


class RevisionStore
  class << self
    # include Finders
    # include Groupers
    # include Sorters

    def database
      @database ||= initialize_database
    end

    def initialize_database
      db ||= YAML::Store.new(filename)
      db.transaction do
        db ||= []
      end
      db
    end

    def filename
      @filename || 'db/revisions'
    end

    def filename=(name)
      @filename = name
    end

    def all
      revisions = []
      raw_revisions.each_with_index do |data, id|
        revisions << RevisedIdea.new(data.merge("id" => id+1))
      end
      revisions
    end

    def size
      raw_revisions.length
    end

    def create(attributes)
      new_revision = RevisedIdea.new(attributes.merge("resources" => Array(attributes['resources'])))
      database.transaction do
        database['ideas'] << new_revision.to_h
      end
    end

    def update(id, attributes)
      resources = split_resources(attributes['resources'])
      updated_revision = Idea.new(attributes.merge( "id" => id, 
                                                "created_at" => find(id).created_at, 
                                                "updated_at" => Time.now.to_s, 
                                                "revision" => find(id).revision + 1, 
                                                "resources" => resources ))
      database.transaction do
        database['ideas'][id.to_i-1] = updated_revision.to_h
      end
    end

    # TO DO: find a module to put this in
    def split_resources(resources)
      return if resources.nil? || resources.class == Array
      if resources.length < 2 
        Array(resources.split(", ")) 
      else
        Array(resources)
      end
    end

    def delete(position)
      database.transaction do
        database['ideas'].delete_at(position-1)
      end
    end

    def delete_all
      database.transaction do
        database['ideas'] = []
      end
    end

    def raw_revisions
      database.transaction do |db|
        database['ideas'] ||= []
      end
    end

  end
end