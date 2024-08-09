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
  # Associations
  it { should belong_to :vault }

  # Validations
  it { should validate_presence_of :name }
  it { should validate_presence_of :username }
  it { should validate_presence_of :encrypted_password }

  describe 'Validate scoped uniqueness' do
    let(:user) { create(:user) }
    let(:vault) { create(:vault, user:) }
    before { create(:password_record, vault:) }

    it { should validate_uniqueness_of(:name).scoped_to(:vault_id) }
  end
end
