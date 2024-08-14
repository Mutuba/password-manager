# frozen_string_literal: true

# == Schema Information
#
# Table name: vaults
#
#  id                   :bigint           not null, primary key
#  name                 :string           not null
#  user_id              :bigint           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  encrypted_master_key :text             not null
#  salt                 :binary           not null
#
require 'rails_helper'

RSpec.describe Vault, type: :model do
  describe 'associations' do
    it { should belong_to :user }
    it { should have_many :password_records }
  end

  describe 'validations' do
    let(:vault) { build(:vault) }
    before { vault.generate_encrypted_master_key(Random.new_seed) }
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  end

  describe 'columns validations' do
    it { should have_db_column(:name).of_type :string }
    it { should have_db_column(:encrypted_master_key).of_type :text }
    it { should have_db_column(:salt).of_type :binary }
  end
end
