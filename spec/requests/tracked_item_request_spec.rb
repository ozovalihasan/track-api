require 'rails_helper'

RSpec.describe 'TrackedItems', type: :request do
  let(:password) { Faker::Lorem.word }
  let!(:user) { user_with_password(password) }
  let!(:tracked_items) { tracked_items_with_user(user) }
  let(:token) do
    post '/login', params: {
      username: user.username,
      password: password
    }

    token = JSON.parse(response.body)['token']
  end

  describe 'POST /trackedItems' do
    before do
      post '/tracked_items', headers: {
        Authorization: "bearer #{token}"
      }, params: {
        tracked_item: {
          name: 'dog'
        }
      }
    end

    it 'creates a tracked item' do
      res = JSON.parse(response.body)
      expect(res).not_to be_empty
      expect(res['id']).to eq(6)
      expect(res['name']).to eq('dog')
    end

    it 'returns status code 201' do
      expect(response).to have_http_status(201)
    end
  end

  describe 'GET /trackedItems' do
    before do
      get '/tracked_items', headers: {
        'Content-Type': 'application/json',
        Authorization: "bearer #{token}"
      }
    end

    it 'returns tracked items' do
      res = JSON.parse(response.body)

      expect(res).not_to be_empty
      expect(res.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /trackedItems/:id' do
    before do
      get '/tracked_items/1', headers: {
        'Content-Type': 'application/json',
        Authorization: "bearer #{token}"
      }
    end

    it 'returns the tracked item' do
      res = JSON.parse(response.body)
      expect(res).not_to be_empty
      expect(res['tracked_item']['id']).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /tracked_items' do
    before do
      put '/tracked_items/1', params: { tracked_item: { name: 'hasan' } }, headers: {
        Authorization: "bearer #{token}"
      }
    end

    it 'updates the tracked item' do
      res = JSON.parse(response.body)
      expect(res['name']).to eq('hasan')
      expect(res['id']).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE /trackedItems/:id' do
    before do
      delete '/tracked_items/1', headers: {
        'Content-Type': 'application/json',
        Authorization: "bearer #{token}"
      }
    end

    it 'deletes the tracked item' do
      expect(TrackedItem.all.size).to eq(4)
    end
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
