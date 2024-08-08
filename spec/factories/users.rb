FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password_digest { "SecretPassword123" }
  end
end
