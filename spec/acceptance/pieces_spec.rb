# spec/acceptance/orders_spec.rb
require 'acceptance_helper'

resource 'Pieces' do
  explanation 'Pieces resource'

  header 'Authorization', :bearer
  header 'Content-Type', 'application/json'

  let(:password) { 'Mock Password' }
  let!(:user) { user_with_password(password) }
  let!(:tracked_items) do
    tracked_items_with_user(user, count: 3)
  end
  let!(:pieces) { pieces_with_tracked_items(tracked_items, count: 3) }
  let!(:piece) do
    { name: 'Mock Piece Name',
      frequency_time: 86_400,
      frequency: 2,
      percentage: 33 }
  end
  let(:bearer) do
    token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
    "Bearer #{token}"
  end

  get '/pieces' do
    parameter :token, 'Token', required: true, with_example: true

    context '200' do
      example 'Pieces are Listed ' do
        do_request
        res = JSON.parse(response_body)

        expect(res).not_to be_empty
        expect(res.size).to eq(3)
        expect(status).to eq(200)
      end
    end
  end

  get '/pieces/1' do
    parameter :token, 'Token', required: true, with_example: true

    context '200' do
      example 'The piece is shown' do
        do_request
        res = JSON.parse(response_body)

        expect(res).not_to be_empty
        expect(res['piece']['id']).to eq(1)
        expect(status).to eq(200)
      end
    end
  end

  post '/pieces' do
    let(:raw_post) { params.to_json }

    parameter :token, 'Token', required: true, with_example: true
    parameter :tracked_item_id, 'Tracked Item Id', required: true, with_example: true
    with_options scope: :piece, with_example: true do
      parameter :name, 'Mock Piece Name', required: true
      parameter :frequency_time, '86400 For Day, 604800 For Week', required: true
      parameter :frequency, 'Planned repetition ', required: true
      parameter :percentage, 'Percentage of completed part', required: true
    end

    context '201' do
      example 'A piece is created' do
        request = {
          tracked_item_id: 1,
          piece: piece
        }
        do_request(request)
        res = JSON.parse(response_body)

        expect(res).not_to be_empty
        expect(res['name']).to eq('Mock Piece Name')
        expect(res['tracked_item_id']).to eq(1)
        expect(status).to eq(201)
      end
    end
  end

  put '/pieces/1' do
    let(:raw_post) { params.to_json }

    parameter :token, 'Token', required: true, with_example: true
    parameter :tracked_item_id, 'Tracked Item Id', with_example: true
    with_options scope: :tracked_item, with_example: true do
      parameter :name, 'Mock Piece Name'
      parameter :frequency_time, '86400 For Day, 604800 For Week'
      parameter :frequency, 'Planned repetition '
      parameter :percentage, 'Percentage of completed part'
    end

    context '200' do
      example 'The piece is updated' do
        request = {
          piece: {
            name: 'water'
          }
        }
        do_request(request)
        res = JSON.parse(response_body)

        expect(res['name']).to eq('water')
        expect(res['id']).to eq(1)
        expect(status).to eq(200)
      end
    end
  end

  delete '/pieces/1' do
    parameter :token, 'Token', required: true, with_example: true

    context '204' do
      example 'The piece is destroyed' do
        do_request

        expect(Piece.all.size).to eq(2)
        expect(status).to eq(204)
      end
    end
  end
end
