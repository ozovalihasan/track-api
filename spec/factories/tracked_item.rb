FactoryBot.define do
  factory :tracked_item do
    name { Faker::Lorem.word }
    association :user
  end
end

def tracked_items_with_user(user, count: 5)
  FactoryBot.create_list(:tracked_item, count, user: user)
end
