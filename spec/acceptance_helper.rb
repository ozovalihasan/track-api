require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = [:json]
  config.request_headers_to_include = %w[Content-Type Authorization]
  config.response_headers_to_include = ['Content-Type']
end
