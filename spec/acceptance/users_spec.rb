# spec/acceptance/orders_spec.rb
require 'acceptance_helper'
# rubocop:disable Metrics/BlockLength
resource 'Users' do
  explanation 'Users resource'

  header 'Content-Type', 'application/json'

  post '/users' do
    let(:raw_post) { params.to_json }

    parameter :username, 'Username', required: true, with_example: true
    parameter :password, 'Password', required: true, with_example: true

    context '200' do
      example 'A user signs up' do
        request = {
          username: 'Mock Name',
          password: 'Mock Password'
        }
        do_request(request)

        res = JSON.parse(response_body)
        expect(res['user']).not_to be_empty
        expect(res['user']['username']).to eq('Mock Name')
        expect(res['token']).not_to be_empty
        expect(status).to eq(200)
      end
    end
  end

  let(:user_create) { User.create(username: 'Mock Name', password: 'Mock Password') }

  post '/login' do
    let(:raw_post) { params.to_json }
    parameter :username, 'Username', required: true, with_example: true
    parameter :password, 'Password', required: true, with_example: true

    context '200' do
      example 'A user log in ' do
        user_create
        request = {
          username: 'Mock Name',
          password: 'Mock Password'
        }
        do_request(request)
        res = JSON.parse(response_body)

        expect(res['user']).not_to be_empty
        expect(res['user']['username']).to eq('Mock Name')
        expect(res['token']).not_to be_empty
        expect(status).to eq(200)
      end
    end
  end

  header 'Authorization', :bearer

  get '/auto_login' do
    parameter :token, 'Token', required: true, with_example: true

    let(:bearer) do
      user = user_create
      token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
      "Bearer #{token}"
    end
    context '200' do
      example 'A user logs in automatically by using token' do
        bearer
        do_request
        res = JSON.parse(response_body)

        expect(res['username']).to eq('Mock Name')
        expect(status).to eq(200)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
