# frozen_string_literal: true

class AddUniqueIndexToUsersUsername < ActiveRecord::Migration[7.1]
  def change
    add_index(:users, :username, unique: true)
  end
end
