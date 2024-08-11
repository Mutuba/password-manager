# frozen_string_literal: true

# == Schema Information
#
# Table name: password_records
#
#  id                 :bigint           not null, primary key
#  vault_id           :bigint           not null
#  name               :string           not null
#  username           :string           not null
#  encrypted_password :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require 'rails_helper'

RSpec.describe PasswordRecord, type: :model do
  describe 'Associations' do
    it { should belong_to :vault }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :username }
    it { should validate_presence_of :encrypted_password }
  end

  describe 'Validate scoped uniqueness' do
    subject { build(:password_record) }
    it { should validate_uniqueness_of(:name).scoped_to(:vault_id) }
  end
end
