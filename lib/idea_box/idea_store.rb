require 'yaml/store'

class IdeaStore
  class << self
    def database
      if @env == "test"
        @database ||= YAML::Store.new('db/test')
        return @database
      end

      return @database if @database

      @database ||= YAML::Store.new('db/ideabox')
      @database.transaction do
        @database['ideas'] || []
      end
      @database
    end

    def set_test
      @env = "test"
    end

    def all
      ideas = []
      raw_ideas.each do |data|
        ideas << Idea.new(data.merge("id" => data["id"]))
      end
      ideas
    end

    def create(attributes)
      new_idea = Idea.new(attributes)
      database.transaction do
        database['ideas'] << new_idea.to_h
      end
    end

    def find(id)
      raw_idea = find_raw_idea(id)
      Idea.new(raw_idea.merge("id" => id))
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

    def sort_by_id(group)
      find_all_by_group(group).sort_by(&:id)
    end

    # def find_all_by_time_created(range_start, range_end)
    #   all.group_by
    #   range_start..range_end.include?
    #   Date.parse(date).strftime "%l : %M %p"
    # end

    def group_all_by_day_created
      all.group_by do |idea|
        idea.created_at.strftime "%a"
      end
    end

    def update(id, attributes)
      new_attrs = {
        "id" => id,
        "title" => attributes["title"] || find(id).title,
        "description" => attributes["description"] || find(id).description,
        "rank" => attributes["rank"] || find(id).rank,
        "created_at" => attributes["created_at"] || find(id).created_at,
        "updated_at" => Time.now,
        "revision" => find(id).revision + 1 }

      create(new_attrs)
    end

    def delete(position)
      database.transaction do
        database['ideas'].delete_at(position)
      end
    end

    def raw_ideas
      database.transaction do |db|
        database['ideas'] ||= []
      end
    end

    def find_raw_idea(id)
      database.transaction do
        found = database['ideas'].select do |idea|
          idea['id'] == id
        end
        found.last
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