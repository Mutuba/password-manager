# frozen_string_literal: true

class AddExtraColumnsToPasswordRecord < ActiveRecord::Migration[7.1]
  def change
    add_column(:password_records, :notes, :text)
    add_column(:password_records, :url, :string)
    add_column(:password_records, :last_used_at, :datetime)
    add_column(:password_records, :expired_at, :datetime)
  end
end
