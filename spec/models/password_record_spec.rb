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
    let(:user) { create(:user) }
    let(:vault) { build(:vault, user:) }
    let(:valid_password) { 'FavouritePassword123!' }

    before do
      vault.add_encrypted_master_key(valid_password)
      vault.save!
    end

    let!(:existing_password_record) { create(:password_record, vault:) }

    it do
      should validate_uniqueness_of(:name).scoped_to(:vault_id)
    end
  end
end
