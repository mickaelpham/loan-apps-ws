# frozen_string_literal: true

require 'sinatra'
require 'net/http'
require 'json'

require_relative 'gateways/credit_bureau_gateway'
require_relative 'best_quote'

set :port, 80
set :bind, '0.0.0.0'

post '/loan-request' do
  request.body.rewind # in case someone already read it
  data = JSON.parse(request.body.read, symbolize_names: true)

  logger.info "received loan request for #{data[:name]}"

  credit_bureau = CreditBureauGateway.credit_score(data[:ssn])
  logger.info "retrieved credit score #{credit_bureau[:credit_score]}"

  best_quote = BestQuote.new(credit_bureau[:credit_score], data[:amount]).call
  logger.info "retrieve best quote from #{best_quote[:bank]}"

  response = {
    full_name: data[:name],
    social_security: data[:ssn],
    credit_score: credit_bureau[:credit_score],
    bank_quote: best_quote[:bank],
    amount: data[:amount],
    interest_rate: best_quote[:interest_rate]
  }

  [201, { 'Content-Type' => 'application/json' }, response.to_json]
end
