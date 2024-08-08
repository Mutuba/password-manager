FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    password_digest { "SecretPassword123" }
  end
end
