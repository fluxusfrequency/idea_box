require 'yaml/store'
require 'time'
require './lib/idea_box/finders'
require './lib/idea_box/groupers'
require './lib/idea_box/sorters'
require './lib/idea_box'


class IdeaStore
  class << self
    include Finders
    include Groupers
    include Sorters

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
      @filename || 'db/ideabox'
    end

    def filename=(name)
      @filename = name
    end

    def current_portfolio
      @current_portfolio
    end

    def current_portfolio=(portfolio_id)
      @current_portfolio = portfolio_id
    end

    def all
      all_ideas.select {|idea| idea.portfolio_id == current_portfolio }
    end

    def all_ideas
      ideas = []
      raw_ideas.each_with_index do |data, id|
        ideas << Idea.new(data.merge("id" => id+1))
      end
      ideas
    end

    def portfolio_size
      all.length
    end

    def size
      raw_ideas.length
    end

    def create(attributes)
      if attributes['resources']
        merge_hash = {"resources" => Array(attributes['resources'])}
      else
        merge_hash = attributes
      end

      new_idea = Idea.new(attributes.merge(merge_hash))
      database.transaction do
        database['ideas'] << new_idea.to_h
      end
      new_idea
    end

    def update(id, attributes)
      old_idea = find(id.to_i)
      revision = RevisionStore.create(old_idea.to_h.merge("idea_id"=>id))
      resources = split_resources(attributes['resources'])
      updated_idea = Idea.new(attributes.merge( 
        "id" => id, 
        "created_at" => find(id).created_at, 
        "updated_at" => Time.now.to_s, 
        "revision" => revision.revision, 
        "resources" => resources ))
      database.transaction do
        database['ideas'][id.to_i-1] = updated_idea.to_h
      end
    end

    def change_portfolio_for_idea(id, portfolio_id)
      update(id, {'portfolio_id' => portfolio_id})
    end

    # TO DO: find a module to put this
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

    def delete_portfolio(id)
      current_portfolio = id
      current_ideas = all.collect(&:to_h)
      database.transaction do
        database['ideas'] = database['ideas'] - current_ideas
      end
    end

    def raw_ideas
      database.transaction do |db|
        database['ideas'] ||= []
      end
    end

  end
end