FactoryBot.define do
  factory :user do
    username { Faker::Lorem.word }
    password { Faker::Lorem.word }
  end
end
