require 'yaml/store'

class IdeaStore
  class << self
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

    def all
      ideas = []
      raw_ideas.each_with_index do |data, id|
        ideas << Idea.new(data.merge("id" => id+1))
      end
      ideas
    end

    def size
      raw_ideas.length
    end

    def create(attributes)
      new_idea = Idea.new(attributes)
      database.transaction do
        database['ideas'] << new_idea.to_h
      end
    end

    def find(id)
      raw_idea = find_raw_idea(id)
      puts raw_idea
      Idea.new(raw_idea.to_h)
    end

    def find_history_for_idea(id)
     group_all_by_id[id]
    end

    def group_all_by_id
      all.group_by do |idea|
        idea.id
      end
    end

    def find_all_by_tags(*tags)
      raw_ideas = tags.collect do |tag|
        find_raw_idea_by_tag(tag)
      end
      raw_ideas.compact.flatten.collect do |raw_idea|
        Idea.new(raw_idea)
      end
    end

    def group_all_by_tags
      all.group_by do |idea|
        idea.tags
      end
    end

    def find_all_by_time_created(range_start, range_end)
      #12:00AM, 12:59AM
      start = Time.strptime(range_start, "%l:%M%p")
      stop = Time.strptime(range_stop, "%l:%M%p")
      find_ideas_between_times(start, stop).values
    end

    def find_ideas_between_times(start, stop)
      group_all_by_time_created.select do |key, value|
        (start..stop).cover?(key)
      end
    end

    def group_all_by_time_created
      all.group_by do |idea|
        idea.created_at.strftime "%l:%M%p"
      end
    end

    def find_all_by_group(group)
      group_all_by_group[group]
    end

    def group_all_by_group
      all.group_by do |idea|
        idea.group
      end
    end

    def sort_by_rank(group)
      find_all_by_group(group).sort_by(&:rank).reverse
    end

    def sort_by_group(group)
      find_all_by_group(group).sort_by(&:id)
    end

    def group_all_by_day_created
      all.group_by do |idea|
        idea.created_at.strftime "%a"
      end
    end

    def update(id, attributes)
      updated_idea = Idea.new(attributes.merge("id" => id))
      puts updated_idea
      database.transaction do
        database['ideas'][id] = updated_idea.to_h
      end
      # new_attrs = {
      #   "id" => id,
      #   "title" => attributes["title"] || find(id).title,
      #   "description" => attributes["description"] || find(id).description,
      #   "rank" => attributes["rank"] || find(id).rank,
      #   "created_at" => attributes["created_at"] || find(id).created_at,
      #   "updated_at" => Time.now,
      #   "revision" => find(id).revision + 1 }

      # create(new_attrs)
    end

    def delete(id)
      database.transaction do
        database['ideas'].delete_at(position)
      end
    end

    def delete_all
      database.transaction do
        database['ideas'] = []
      end
    end

    def raw_ideas
      database.transaction do |db|
        database['ideas'] ||= []
      end
    end

    def find_raw_idea(id)
      find_raw_ideas(id).last
    end

    def find_raw_ideas(id)
      database.transaction do
        database['ideas'].select do |idea|
          idea['id'] == id
        end
      end
    end

    def find_raw_idea_by_tag(tag)
      result = []
      database.transaction do
        database['ideas'].each do |idea|
          result << idea if idea['tags'].to_s.include?(tag)
        end
      end
      result
    end

  end
end