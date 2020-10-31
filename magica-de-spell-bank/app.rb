# frozen_string_literal: true

require 'sinatra'
require 'net/http'
require 'json'

set :port, 80
set :bind, '0.0.0.0'

RULES = {
  # Do not lend money to bad credits
  500 => false,
  # Cheap loans with good credit
  600 => 0.1,
  700 => 0.25,
  # Making sure Scrooge McDuck pays the extra interests
  850 => 0.99
}.freeze

# POST /evil-loans
#
#   Sample Request:
#   {
#     "amount": "John Doe",
#     "credit_score": 750
#   }
#
#   Sample Response:
#   {
#     "approved": true,
#     "interest_rate": 0.25
#   }
#
post '/evil-loans' do
  request.body.rewind # in case someone already read it

  loan_request = JSON.parse(request.body.read, symbolize_names: true)
  logger.info "received loan request for #{loan_request[:amount]} with credit score #{loan_request[:credit_score]}"

  rule_key = RULES.keys.detect { |ceiling| loan_request[:credit_score] <= ceiling }

  response = if RULES[rule_key].is_a?(Float)
               { approved: true, interest_rate: RULES[rule_key] }
             else
               { approved: false }
             end

  [201, { 'Content-Type' => 'application/json' }, response.to_json]
end
