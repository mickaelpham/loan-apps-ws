# frozen_string_literal: true

require 'sinatra'
require 'net/http'
require 'json'

set :port, 80
set :bind, '0.0.0.0'

post '/loan-request' do
  request.body.rewind # in case someone already read it
  data = JSON.parse(request.body.read, symbolize_names: true)

  logger.info "received loan request for #{data[:name]}"

  # Fetch the credit score from the credit bureau
  uri = URI("http://credit-bureau/credit-score?ssn=#{data[:ssn]}")
  body = Net::HTTP.get(uri)
  credit_bureau = JSON.parse(body, symbolize_names: true)

  logger.info "retrieved credit score #{credit_bureau[:credit_score]}"

  response = {
    full_name: data[:name],
    social_security: data[:ssn],
    credit_score: credit_bureau[:credit_score]
  }

  [201, { 'Content-Type' => 'application/json' }, response.to_json]
end
