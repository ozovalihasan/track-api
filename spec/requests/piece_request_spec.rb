require 'rails_helper'

RSpec.describe 'Piece', type: :request do
  let(:password) { Faker::Lorem.word }
  let!(:user) { user_with_password(password) }
  let!(:user2) { user_with_password(password) }
  let!(:tracked_items) { tracked_items_with_user(user, count: 3) }
  let!(:tracked_items2) { tracked_items_with_user(user2, count: 3) }
  let!(:pieces) { pieces_with_tracked_items(tracked_items, count: 3) }
  let!(:pieces2) { pieces_with_tracked_items(tracked_items2, count: 3) }
  let(:piece) do
    { name: 'qui',
      frequency_time: 4_199_091_651,
      frequency: 5,
      percentage: 33 }
  end
  let(:token) do
    post '/login', params: {
      username: user.username,
      password: password
    }

    JSON.parse(response.body)['token']
  end

  describe 'GET /pieces' do
    it 'returns all pieces of user' do
      get '/pieces', headers: {
        'Content-Type': 'application/json',
        Authorization: "bearer #{token}"
      }
      res = JSON.parse(response.body)

      expect(res).not_to be_empty
      expect(res.size).to eq(3)
    end

    it 'returns status code 200' do
      get '/pieces', headers: {
        'Content-Type': 'application/json',
        Authorization: "bearer #{token}"
      }
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /pieces/:id' do
    it 'returns tracked items' do
      get '/pieces/1', headers: {
        'Content-Type': 'application/json',
        Authorization: "bearer #{token}"
      }
      res = JSON.parse(response.body)
      expect(res).not_to be_empty
      expect(res['piece']['id']).to eq(1)
    end

    it 'returns status code 200' do
      get '/pieces/1', headers: {
        'Content-Type': 'application/json',
        Authorization: "bearer #{token}"
      }
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /pieces' do
    it 'returns created piece' do
      post '/pieces', params: {
        piece: piece, tracked_item_id: 1
      }, headers: {
        Authorization: "bearer #{token}"
      }
      res = JSON.parse(response.body)
      expect(res).not_to be_empty
      expect(res['name']).to eq(piece[:name])
    end

    it 'returns status code 201' do
      post '/pieces', params: {
        piece: piece, tracked_item_id: 1
      }, headers: {
        Authorization: "bearer #{token}"
      }
      expect(response).to have_http_status(201)
    end
  end

  describe 'PUT /pieces' do
    it 'updates the piece item' do
      put '/pieces/1',
          params: {
            piece: {
              name: 'pill'
            }
          },
          headers: {
            Authorization: "bearer #{token}"
          }
      res = JSON.parse(response.body)
      expect(res['name']).to eq('pill')
      expect(res['id']).to eq(1)
    end

    it 'returns status code 200' do
      put '/pieces/1',
          params: {
            piece: {
              name: 'pill'
            }
          },
          headers: {
            Authorization: "bearer #{token}"
          }
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE /trackedItems/:id' do
    it 'deletes the piece' do
      delete '/pieces/1', headers: {
        'Content-Type': 'application/json',
        Authorization: "bearer #{token}"
      }
      expect(Piece.all.length).to eq(5)
    end

    it 'returns status code 204' do
      delete '/pieces/1', headers: {
        'Content-Type': 'application/json',
        Authorization: "bearer #{token}"
      }
      expect(response).to have_http_status(204)
    end
  end
end
