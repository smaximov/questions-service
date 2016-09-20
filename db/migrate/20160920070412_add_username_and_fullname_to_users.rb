# frozen_string_literal: true

class AddUsernameAndFullnameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :username, :string, null: false
    add_column :users, :fullname, :string, null: false

    add_index :users, :username, unique: true
  end
end
