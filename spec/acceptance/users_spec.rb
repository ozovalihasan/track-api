# spec/acceptance/orders_spec.rb
require 'acceptance_helper'

resource 'Users' do
  explanation 'Users resource'

  header 'Content-Type', 'application/json'

  post '/users' do
    with_options scope: :data, with_example: true do
      parameter :username, 'Username', required: true
      parameter :password, 'Password', required: true
    end

    context '200' do
      example_request 'Signing up a user with password' do
        expect(status).to eq(200)
      end
    end
  end

  # put '/orders/:id' do
  #   with_options scope: :data, with_example: true do
  #     parameter :name, 'The order name', required: true
  #     parameter :amount
  #     parameter :description, 'The order description'
  #   end

  #   context '200' do
  #     let(:id) { 1 }

  #     example 'Update an order' do
  #       request = {
  #         data: {
  #           name: 'order',
  #           amount: 1,
  #           description: 'fast order'
  #         }
  #       }

  #       # It's also possible to extract types of parameters when you pass data through `do_request` method.
  #       do_request(request)

  #       expected_response = {
  #         data: {
  #           name: 'order',
  #           amount: 1,
  #           description: 'fast order'
  #         }
  #       }
  #       expect(status).to eq(200)
  #       expect(response_body).to eq(expected_response)
  #     end
  #   end

  #   context '400' do
  #     let(:id) { 'a' }

  #     example_request 'Invalid request' do
  #       expect(status).to eq(400)
  #     end
  #   end

  #   context '404' do
  #     let(:id) { 0 }

  #     example_request 'Order is not found' do
  #       expect(status).to eq(404)
  #     end
  #   end
  # end
end
