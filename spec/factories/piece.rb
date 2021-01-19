FactoryBot.define do
  factory :piece do
    name { Faker::Lorem.word }
    frequency_time { Faker::Number.number(digits: 10) }
    frequency { Faker::Number.number(digits: 1) }
    percentage { Faker::Number.number(digits: 2) }
    association :tracked_item
  end
end

def pieces_with_tracked_items(tracked_items, count: 10)
  FactoryBot.create_list(:piece, count, tracked_item: tracked_items.sample)
end
