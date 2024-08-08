require 'rails_helper'

RSpec.describe User, type: :model do
  # Associations
  it { should have_many :vaults }

  # Validate columns
  it { should have_db_column(:username).of_type :string } 
  it { should have_db_column(:password_digest).of_type :string } 
  
  # Presence Validation
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:username) }
end
