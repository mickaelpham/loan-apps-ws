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
#     "CreditScore": 750,
#     "Amount": 1000
#   }
#
#   Sample Response:
#   {
#     "Approved": true,
#     "interest_rate": 0.25
#   }
#
post '/loans' do
  request.body.rewind # in case someone already read it

  loan_request = JSON.parse(request.body.read)
  logger.info "received loan request for #{loan_request['Amount']} with credit score #{loan_request['CreditScore']}"

  rule_key = RULES.keys.detect { |ceiling| loan_request['CreditScore'] <= ceiling }

  response = {
    'Approved' => true,
    'InterestRate' => RULES[rule_key]
  }

  [201, { 'Content-Type' => 'application/json' }, response.to_json]
end
