require 'rails_helper'

RSpec.describe TrackedItem, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:pieces).dependent(:destroy) }
  end
end
