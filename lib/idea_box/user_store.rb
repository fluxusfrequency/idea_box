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
      load_databases_for(new_user.id)
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

    def find_by_username(username)
      raw_user = find_raw_user_by_username(username)
      User.new(raw_user.to_h.merge('password' => raw_user['password'])) if raw_user
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

    def find_raw_user_by_username(username)
      database.transaction do
        begin
          database['users'].find do |user|
            user['username'] == username
          end
        rescue
          return
        end
      end
    end

    def load_databases_for(user_id)
      load_ideas_for(user_id)
      load_revisions_for(user_id)
    end

    def load_ideas_for(user_id)
      IdeaStore.filename = "db/user/#{user_id}_ideas"
    end

    def load_revisions_for(user_id)
      RevisionStore.filename = "db/user/#{user_id}_revisions"
    end

    def create_portfolio(user_id, portfolio_name)
      user = find(user_id)
      UserStore.update(user_id, user.to_h.merge({'portfolios' => user.portfolios.merge({user.portfolios.keys.max.to_i + 1 => portfolio_name})}))
    end

    def load_portfolio_for(user_id, portfolio)
      user = find(user_id)
      IdeaStore.current_portfolio = user.portfolios.key(portfolio)
    end

    def delete_portfolio(user_id, portfolio_id)
      IdeaStore.delete_portfolio(portfolio_id)
      user = UserStore.find(user_id)
      user.portfolios.delete(portfolio_id.to_i)
      UserStore.update(user_id, user.to_h) 
      load_portfolio_for(user_id, user.portfolios.values.first)
    end

    def rename_portfolio(user_id, portfolio_id, new_portfolio_name)
      user = find(user_id)
      user.portfolios[portfolio_id] = new_portfolio_name
      UserStore.update(user.id, user.to_h)
      IdeaStore.current_portfolio = user.portfolios.key(new_portfolio_name)
    end
  end
end