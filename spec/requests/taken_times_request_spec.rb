require 'rails_helper'

RSpec.describe 'TakenTimes', type: :request do
  let(:password) { Faker::Lorem.word }
  let!(:user) { user_with_password(password) }
  let!(:user2) { user_with_password(password) }
  let!(:tracked_items) { tracked_items_with_user(user, count: 3) }
  let!(:tracked_items2) { tracked_items_with_user(user2, count: 3) }
  let!(:pieces) { pieces_with_tracked_items(tracked_items, count: 3) }
  let!(:pieces2) { pieces_with_tracked_items(tracked_items2, count: 3) }
  let!(:taken_times) { taken_times_with_pieces(pieces, count: 3) }
  let!(:taken_times2) { taken_times_with_pieces(pieces2, count: 3) }

  let(:token) do
    post '/login', params: {
      username: user.username,
      password: password
    }

    JSON.parse(response.body)['token']
  end

  describe 'POST /taken_times' do
    before do
      post '/taken_times', headers: {
        Authorization: "bearer #{token}"
      }, params: {
        piece_id: 1
      }
    end

    it 'creates a taken time' do
      res = JSON.parse(response.body)
      expect(res).not_to be_empty
      expect(res['id']).to eq(7)
      expect(res['piece']['id']).to eq(1)
    end

    it 'returns status code 201' do
      expect(response).to have_http_status(201)
    end
  end

  describe 'GET /taken_times' do
    before do
      get '/taken_times', headers: {
        # 'Content-Type': 'application/json',
        Authorization: "bearer #{token}"
      }
    end

    it 'returns taken times' do
      res = JSON.parse(response.body)
      expect(res).not_to be_empty
      expect(res.size).to eq(3)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE /taken_times/:id' do
    before do
      delete '/taken_times/1', headers: {
        'Content-Type': 'application/json',
        Authorization: 'bearer '.concat(token)
      }
    end

    it 'deletes the taken time' do
      expect(TakenTime.all.size).to eq(5)
    end
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
