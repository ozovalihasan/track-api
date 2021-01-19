# spec/acceptance/orders_spec.rb
require 'acceptance_helper'
# rubocop:disable Metrics/BlockLength
resource 'TrackedItems' do
  explanation 'TrackedItems resource'

  header 'Authorization', :bearer
  header 'Content-Type', 'application/json'

  let(:username) { 'Mock Username' }
  let(:password) { 'Mock Password' }
  let(:user_create) { User.create(username: username, password: password) }
  let!(:user) { user_with_password(password) }
  let!(:tracked_items) do
    user = user_create
    tracked_items_with_user(user, count: 3)
  end
  let(:bearer) do
    user = user_create
    token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
    "Bearer #{token}"
  end

  get '/tracked_items' do
    parameter :token, 'Token', required: true, with_example: true

    context '200' do
      example 'Tracked items are Listed ' do
        do_request
        res = JSON.parse(response_body)

        expect(res).not_to be_empty
        expect(res.size).to eq(3)
        expect(status).to eq(200)
      end
    end
  end

  get '/tracked_items/1' do
    parameter :token, 'Token', required: true, with_example: true

    context '200' do
      example 'The tracked item is shown' do
        do_request
        res = JSON.parse(response_body)

        expect(res).not_to be_empty
        expect(res['tracked_item']['id']).to eq(1)
        expect(status).to eq(200)
      end
    end
  end

  post '/tracked_items' do
    let(:raw_post) { params.to_json }

    parameter :token, 'Token', required: true, with_example: true
    with_options scope: :tracked_item, with_example: true do
      parameter :name, 'Tracked Item Name', required: true
    end

    context '201' do
      example 'A tracked item is created' do
        request = {
          tracked_item: {
            name: 'cat'
          }
        }
        do_request(request)
        res = JSON.parse(response_body)

        expect(res).not_to be_empty
        expect(res['id']).to eq(4)
        expect(res['name']).to eq('cat')
        expect(status).to eq(201)
      end
    end
  end

  put '/tracked_items/1' do
    let(:raw_post) { params.to_json }

    parameter :token, 'Token', required: true, with_example: true
    with_options scope: :tracked_item, with_example: true do
      parameter :name, 'Tracked Item Name'
    end

    context '200' do
      example 'The tracked item is updated' do
        request = {
          tracked_item: {
            name: 'dog'
          }
        }
        do_request(request)
        res = JSON.parse(response_body)

        expect(res['name']).to eq('dog')
        expect(res['id']).to eq(1)
        expect(status).to eq(200)
      end
    end
  end

  delete '/tracked_items/1' do
    parameter :token, 'Token', required: true, with_example: true

    context '204' do
      example 'The tracked item is destroyed' do
        do_request

        expect(TrackedItem.all.size).to eq(2)
        expect(status).to eq(204)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
