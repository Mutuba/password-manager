require 'rails_helper'

RSpec.describe Vault, type: :model do
  # Associations
  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of(:name) }

  # Validate columns
  it { is_expected.to have_db_column(:name).of_type :string }
end
