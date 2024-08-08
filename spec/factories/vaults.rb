FactoryBot.define do
  factory :vault do
    name { Faker::Name.name }
    association :user, factory: :user
  end
end
