# frozen_string_literal: true

# == Schema Information
#
# Table name: vaults
#
#  id                 :bigint           not null, primary key
#  name               :string           not null
#  user_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  unlock_code        :text             not null
#  salt               :binary           not null
#  description        :text
#  last_accessed_at   :datetime
#  vault_type         :integer          default("personal"), not null
#  status             :integer          default("active"), not null
#  access_count       :integer          default(0), not null
#  is_shared          :boolean          default(FALSE)
#  shared_with        :jsonb
#  expiration_date    :datetime
#  encrypted_metadata :text
#  failed_attempts    :integer          default(0)
#  unlock_code_hint   :string
#
require "rails_helper"

RSpec.describe(Vault, type: :model) do
  let(:valid_password) { "FavouritePassword123!" }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:password_records) }
  end

  describe "validations" do
    let!(:vault) { create(:vault, unlock_code: valid_password) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  end

  describe "columns validations" do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:unlock_code).of_type(:text) }
    it { should have_db_column(:salt).of_type(:binary) }
    it { should define_enum_for(:status).with_values([:active, :archived, :deleted, :locked]) }
    it { should define_enum_for(:vault_type).with_values([:personal, :business, :shared, :temporary]) }
  end

  describe "#authenticate_master_password" do
    let(:vault) { create(:vault, unlock_code: valid_password) }

    context "with correct password" do
      it "should return true" do
        expect(vault.authenticate_vault(valid_password)).to(eq(true))
      end
    end

    context "with incorrect password" do
      it "should return false" do
        expect(vault.authenticate_vault("SecretPassword")).to(eq(false))
      end
    end
  end
end
