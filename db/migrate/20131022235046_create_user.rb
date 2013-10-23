class CreateUser < ActiveRecord::Migration
  def change
    create_table :user do |t|
      t.string :username
    end
  end
end
