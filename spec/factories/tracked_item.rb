FactoryBot.define do
  factory :tracked_item do
    name { Faker::Lorem.word }
    user_id {}
  end
end
