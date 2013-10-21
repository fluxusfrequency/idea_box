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
        database['revisions'] << new_revision.to_h
      end
      new_revision
    end

    def delete(position)
      database.transaction do
        database['revisions'].delete_at(position-1)
      end
    end

    def delete_all
      database.transaction do
        database['revisions'] = []
      end
    end

    def raw_revisions
      database.transaction do |db|
        database['revisions'] ||= []
      end
    end

    def find_all_by_idea_id(id)
      all.find_all {|revision| revision.idea_id == id}
    end

  end
end