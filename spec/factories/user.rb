FactoryBot.define do
  factory :user do
    username { Faker::Lorem.word }
    association :password
  end
end

def user_with_password(password)
  FactoryBot.create(:user, password: password)
end
