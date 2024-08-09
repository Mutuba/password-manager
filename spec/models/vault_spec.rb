# frozen_string_literal: true

# == Schema Information
#
# Table name: vaults
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Vault, type: :model do
  # Associations
  it { should belong_to :user }
  it { should have_many :password_records }
  it { should validate_presence_of(:name) }

  # Validate columns
  it { should have_db_column(:name).of_type :string }
end
