require 'rails_helper'

RSpec.describe Vault, type: :model do
  # Associations
  it { should belong_to :user }
  it { should have_many :password_records }
  it { should validate_presence_of(:name) }

  # Validate columns
  it { should have_db_column(:name).of_type :string }
end
