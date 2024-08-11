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
  describe "associations" do
    it { should belong_to :user }
    it { should have_many :password_records }
  end

  describe "validations" do
    subject { build(:vault) }
    it {should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  end


  describe "columns validations" do
    it { should have_db_column(:name).of_type :string }
  end
end
