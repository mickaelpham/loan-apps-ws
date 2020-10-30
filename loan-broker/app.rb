# frozen_string_literal: true

require 'sinatra'
require 'net/http'
require 'json'

require_relative 'credit_bureau_gateway'

set :port, 80
set :bind, '0.0.0.0'

post '/loan-request' do
  request.body.rewind # in case someone already read it
  data = JSON.parse(request.body.read, symbolize_names: true)

  logger.info "received loan request for #{data[:name]}"

  credit_bureau = CreditBureauGateway.credit_score(data[:ssn])
  logger.info "retrieved credit score #{credit_bureau[:credit_score]}"

  response = {
    full_name: data[:name],
    social_security: data[:ssn],
    credit_score: credit_bureau[:credit_score]
  }

  [201, { 'Content-Type' => 'application/json' }, response.to_json]
end
