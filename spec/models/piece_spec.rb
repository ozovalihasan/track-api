require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:frequency_time) }
    it { should validate_numericality_of(:frequency_time).only_integer }
    it { should validate_presence_of(:frequency) }
    it { should validate_numericality_of(:frequency).only_integer }
  end

  describe 'associations' do
    it { should belong_to(:tracked_item) }
    it { should have_many(:taken_times).dependent(:destroy) }
  end
end
