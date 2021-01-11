require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:password) { Faker::Lorem.word }
  let!(:user) { user_with_password(password) }
  let(:token) do
    post '/login', params: {
      username: user.username,
      password: password
    }

    token = JSON.parse(response.body)['token']
  end

  describe 'POST /users' do
    before do
      username = Faker::Lorem.word
      post '/users', params: {
        username: username,
        password: password
      }
    end

    it 'returns tracked items' do
      res = JSON.parse(response.body)
      expect(res['user']).not_to be_empty
      expect(res['token']).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /login' do
    before do
      post '/login', params: {
        username: user.username,
        password: password
      }
    end

    it 'returns tracked items' do
      res = JSON.parse(response.body)
      expect(res['user']).not_to be_empty
      expect(res['token']).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /auto_login' do
    before do
      get '/auto_login', headers: {
        'Content-Type': 'application/json',
        Authorization: "bearer #{token}"
      }
    end

    it 'returns tracked items' do
      res = JSON.parse(response.body)
      expect(res).not_to be_empty
      expect(res['id']).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
