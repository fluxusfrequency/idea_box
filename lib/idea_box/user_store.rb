require 'yaml/store'
require 'time'
require './lib/idea_box'
# require './lib/idea_box/finders'
# require './lib/idea_box/groupers'
# require './lib/idea_box/sorters'


class UserStore
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
      @filename || 'db/users'
    end

    def filename=(name)
      @filename = name
    end

    def all
      users = []
      raw_users.each_with_index do |data, id|
        users << User.new(data.merge("id" => id+1))
      end
      users
    end

    def size
      raw_users.length
    end

    def create(attributes)
      new_user = User.new(attributes)
      database.transaction do
        database['users'] << new_user.to_h
      end
      new_user
    end

    def update(id, attributes)
      old_user = find(id.to_i)
      updated_user = User.new(old_user.to_h.merge(attributes))
      database.transaction do
        database['users'][id.to_i-1] = updated_user.to_h
      end
    end

    def delete(position)
      database.transaction do
        database['users'].delete_at(position-1)
      end
    end

    def delete_all
      database.transaction do
        database['users'] = []
      end
    end

    def raw_users
      database.transaction do |db|
        database['users'] ||= []
      end
    end

    def find_all_by_idea_id(id)
      all.find_all {|user| user.idea_id == id}
    end

    def find(id)
      raw_user = find_raw_user(id)
      User.new(raw_user.to_h)
    end

    def find_portfolios_for_user(id)
      find(1).portfolios
    end

    def find_raw_user(id)
      database.transaction do
        begin
          database['users'].find do |user|
            user['id'] == id
          end
        rescue
          return
        end
      end
    end

  end
end