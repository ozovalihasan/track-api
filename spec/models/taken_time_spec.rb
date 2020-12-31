require 'rails_helper'

RSpec.describe TakenTime, type: :model do
  describe 'associations' do
    it { should belong_to(:piece) }
  end
end
