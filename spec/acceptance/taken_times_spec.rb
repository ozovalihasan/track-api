# spec/acceptance/orders_spec.rb
require 'acceptance_helper'

resource 'TakenTimes' do
  explanation 'TakenTimes resource'

  header 'Authorization', :bearer
  header 'Content-Type', 'application/json'

  let(:password) { 'Mock Password' }
  let!(:user) { user_with_password(password) }
  let!(:tracked_items) { tracked_items_with_user(user, count: 3) }
  let!(:pieces) { pieces_with_tracked_items(tracked_items, count: 3) }
  let!(:taken_times) { taken_times_with_pieces(pieces, count: 3) }
  let(:bearer) do
    token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
    "Bearer #{token}"
  end

  get '/taken_times' do
    parameter :token, 'Token', required: true, with_example: true

    context '200' do
      example 'Taken times are Listed ' do
        do_request
        res = JSON.parse(response_body)

        expect(res).not_to be_empty
        expect(res.size).to eq(3)
        expect(status).to eq(200)
      end
    end
  end

  post '/taken_times' do
    let(:raw_post) { params.to_json }

    parameter :token, 'Token', required: true, with_example: true
    parameter :piece_id, 'Piece Id', required: true, with_example: true

    context '201' do
      example 'A taken time is created' do
        request = {
          piece_id: 1
        }
        do_request(request)
        res = JSON.parse(response_body)

        expect(res).not_to be_empty
        expect(res['id']).to eq(4)
        expect(res['piece']['id']).to eq(1)
        expect(status).to eq(201)
      end
    end
  end

  delete '/taken_times/1' do
    parameter :token, 'Token', required: true, with_example: true

    context '204' do
      example 'The taken time is destroyed' do
        do_request

        expect(TakenTime.all.size).to eq(2)
        expect(status).to eq(204)
      end
    end
  end
end
