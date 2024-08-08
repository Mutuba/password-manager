require 'rails_helper'

RSpec.describe PasswordRecord, type: :model do

  # Associations
  it { should belong_to :vault }

  # Validations
  it { should validate_presence_of :name }
  it { should validate_presence_of :username }
  it { should validate_presence_of :encrypted_password }

  describe "Validate scoped uniqueness" do
    let(:user) { create(:user) }
    let(:vault) { create(:vault, user: user) }
    before { create(:password_record, vault: vault) }
  
    it { should validate_uniqueness_of(:name).scoped_to(:vault_id) }
  end
end
