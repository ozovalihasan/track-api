require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:username) }
  end

  describe 'associations' do
    it { should have_many(:tracked_items).dependent(:destroy) }
  end

  it 'is valid with valid attributes' do
    User.create(username: 'hasan', password: '1234')
    expect(User.all.length).to eq(1)
  end
end
