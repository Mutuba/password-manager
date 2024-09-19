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
FactoryBot.define do
  factory :password_record do
    association :vault, factory: :vault
    name { Faker::Name.name }
    username { Faker::Internet.username }
    password { Faker::Internet.password(min_length: 10, max_length: 16, mix_case: true, special_characters: true) }
    notes { Faker::Lorem.paragraph }
    url { Faker::Internet.url }

    transient do
      encryption_key { Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true) }
    end

    after(:build) do |password_record, evaluator|
      password_record.encryption_key(evaluator.encryption_key)
    end
  end
end
