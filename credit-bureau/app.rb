# frozen_string_literal: true

require 'sinatra'
require 'json'

set :port, 80
set :bind, '0.0.0.0'

CREDIT_SCORES_DB = {
  '123456789' => 824,
  '234567891' => 542,
  '345678912' => 738
}.freeze

get '/credit-score' do
  logger.info "received credit score request for SSN #{params[:ssn]}"

  response = {
    ssn: params[:ssn],
    credit_score: CREDIT_SCORES_DB.fetch(params[:ssn], 0)
  }

  [200, { 'Content-Type' => 'application/json' }, response.to_json]
end
