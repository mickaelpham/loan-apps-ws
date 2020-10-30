# frozen_string_literal: true

require 'sinatra'
require 'net/http'
require 'json'

set :port, 80
set :bind, '0.0.0.0'

RULES = {
  # everyone is approved, but with a very large interest rate (25%)
  849 => 0.25,
  # except a perfect credit score (4%)
  850 => 0.04
}.freeze

# POST /loans
#
#   Sample Request:
#   {
#     "person": "John Doe",
#     "credit_score": 750
#   }
#
#   Sample Response:
#   {
#     "approved": true,
#     "interest_rate": 0.25
#   }
#
post '/loans' do
  request.body.rewind # in case someone already read it

  loan_request = JSON.parse(request.body.read, symbolize_names: true)
  logger.info "received loan request for #{data[:person]} with credit score #{data[:credit_score}"

  rule_key = RULES.keys.detect { |ceiling| loan_request[:credit_score] <= ceiling }

  response = {
    approved: true,
    interest_rate: RULES[rule_key]
  }

  [201, { 'Content-Type' => 'application/json' }, response.to_json]
end
