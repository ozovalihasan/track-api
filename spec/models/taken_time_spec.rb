require 'rails_helper'

RSpec.describe TakenTime, type: :model do
  let(:password) { Faker::Lorem.word }
  let!(:user) { user_with_password(password) }
  let!(:tracked_items) { tracked_items_with_user(user, count: 1) }
  let!(:pieces) { pieces_with_tracked_items(tracked_items, count: 1) }
  let!(:taken_times) { taken_times_with_pieces(pieces, count: 1) }
  describe 'associations' do
    it { should belong_to(:piece) }
  end

  describe '#as_json' do
    before do
      taken_times[0].update(created_at: 'Thu, 1 Jan 2000 00:00:00.0 UTC +00:00', updated_at: 'Thu, 1 Jan 2000 00:00:00.0 UTC +00:00')
      pieces[0].update(name: 'Mock Piece Name')
    end
    it 'should return updated information of taken time' do
      expect(taken_times[0].as_json).to eq(
        {
          id: 1,
          created_at: 946_684_800,
          updated_at: 946_684_800,
          piece: {
            id: 1,
            name: 'Mock Piece Name'
          },
          tracked_item_id: 1
        }
      )
    end
  end
end
