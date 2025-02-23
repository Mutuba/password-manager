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
#  first_name      :string           default(""), not null
#  last_name       :string           default(""), not null
#
require "rails_helper"

RSpec.describe(User, type: :model) do
  describe "associations" do
    subject(:user) { build(:user) }

    it { should have_many(:vaults) }
  end

  describe "column validations" do
    subject(:user) { build(:user) }

    it 'should validate columns' do
      expect(user).to have_db_column(:username).of_type(:string)
      expect(user).to have_db_column(:password_digest).of_type(:string)
    end
  end

  describe "validations" do
    subject(:user) { build(:user) }

    it "validates presence and uniqueness of attributes" do
      expect(user).to validate_presence_of(:password)
      expect(user).to validate_presence_of(:username)
      expect(user).to validate_presence_of(:email)
      expect(user).to validate_uniqueness_of(:email)
      expect(user).to validate_uniqueness_of(:username)
      expect(user).to validate_length_of(:password).is_at_least(6).on(:create)
    end
  end
end
