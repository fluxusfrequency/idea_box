require 'yaml/store'
require './lib/idea_box'

class SMSStore
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
      @filename || 'db/sms'
    end

    def filename=(name)
      @filename = name
    end

    def all
      smss = []
      raw_smss.each_with_index do |data, id|
        smss << SMS.new(data.merge("id" => id+1))
      end
      smss
    end

    def size
      raw_smss.length
    end

    def create(attributes)
      new_sms = SMS.new(attributes)
      database.transaction do
        database['smss'] << new_sms.to_h
      end
      new_sms
    end

    def update(id, attributes)
      old_sms = find(id.to_i)
      updated_sms = SMS.new(old_sms.to_h.merge(attributes))
      database.transaction do
        database['smss'][id.to_i-1] = updated_sms.to_h
      end
    end

    def delete(position)
      database.transaction do
        database['smss'].delete_at(position-1)
      end
    end

    def delete_all
      database.transaction do
        database['smss'] = []
      end
    end

    def raw_smss
      database.transaction do |db|
        database['smss'] ||= []
      end
    end

    def find_all_by_idea_id(id)
      all.find_all {|sms| sms.idea_id == id}
    end

    def find(id)
      raw_sms = find_raw_sms(id)
      SMS.new(raw_sms.to_h)
    end

    def find_by_sender(sender)
      raw_sms = find_raw_sms_by_sender(sender)
      SMS.new(raw_sms.to_h)
    end

    def find_raw_sms(id)
      database.transaction do
        begin
          database['smss'].find do |sms|
            sms['id'] == id
          end
        rescue
          return
        end
      end
    end

    def find_raw_sms_by_sender(sender)
      database.transaction do
        begin
          database['smss'].find do |sms|
            sms['from'] == sender
          end
        rescue
          return
        end
      end
    end

  end
end