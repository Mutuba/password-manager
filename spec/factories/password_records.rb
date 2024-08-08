FactoryBot.define do
  factory :password_record do
    association :vault, factory: :vault
    name { Faker::Name.name }
    username { Faker::Internet.username }
    encrypted_password { Faker::Alphanumeric.alpha(number: 10) }
  end
end
