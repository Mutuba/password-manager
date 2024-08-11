# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  email           :string
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many :vaults }
  end

  describe 'column validations' do
    it { should have_db_column(:username).of_type :string }
    it { should have_db_column(:password_digest).of_type :string }
  end

  describe 'validations' do
    subject { build(:user) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:username) }
    it do
      should validate_length_of(:password)
        .is_at_least(6)
        .on(:create)
    end
  end
end
