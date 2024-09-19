# frozen_string_literal: true

# == Schema Information
#
# Table name: password_records
#
#  id           :bigint           not null, primary key
#  vault_id     :bigint           not null
#  name         :string           not null
#  username     :string           not null
#  password     :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  notes        :text
#  url          :string
#  last_used_at :datetime
#  expired_at   :datetime
#
require "rails_helper"

RSpec.describe(PasswordRecord, type: :model) do
  describe "Associations" do
    it { should belong_to(:vault) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password) }
  end

  describe "columns validations" do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:username).of_type(:string) }
    it { should have_db_column(:password).of_type(:string) }
    it { should have_db_column(:url).of_type(:string) }
    it { should have_db_column(:notes).of_type(:text) }
    it { should have_db_column(:last_used_at).of_type(:datetime) }
    it { should have_db_column(:expired_at).of_type(:datetime) }
  end

  describe "Validate scoped uniqueness" do
    let(:user) { create(:user) }
    let(:vault) { create(:vault, user:) }
    let!(:password_record) { create(:password_record, vault:) }

    it do
      should validate_uniqueness_of(:name).scoped_to(:vault_id)
    end
  end
end
