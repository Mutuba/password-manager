# frozen_string_literal: true

# == Schema Information
#
# Table name: vaults
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  unlock_code :text             not null
#  salt        :binary           not null
#
FactoryBot.define do
  factory :vault do
    name { Faker::Name.name }
    association :user, factory: :user
    unlock_code { Faker::Internet.password(min_length: 10, max_length: 16, mix_case: true, special_characters: true) }

    trait :with_password_records do
      after(:create) do |vault|
        create_list :password_record, 2, vault: vault
      end
    end
  end
end
