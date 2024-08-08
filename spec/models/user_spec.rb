require 'rails_helper'

RSpec.describe User, type: :model do
  # Associations
  it { is_expected.to have_many :vaults }
  # validate columns
  it { is_expected.to have_db_column(:email).of_type :string } 
  it { is_expected.to have_db_column(:password_digest).of_type :string } 
  it { is_expected.to validate_presence_of(:password_digest) }
  it { is_expected.to validate_presence_of(:email) }
end
