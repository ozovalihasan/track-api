FactoryBot.define do
  factory :taken_time do
    association :piece
  end
end

def taken_times_with_pieces(pieces, count: 10)
  FactoryBot.create_list(:taken_time, count, piece: pieces.sample)
end
