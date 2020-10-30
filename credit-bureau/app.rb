require 'sinatra'
require 'json'

CREDIT_SCORES_DB = {
  '123456789' => 824,
  '234567891' => 542,
  '345678912' => 738
}

get '/credit-score' do
  response = {
    ssn: params[:ssn],
    credit_score: CREDIT_SCORES_DB.fetch(params[:ssn], 0)
  }

  [200, { 'Content-Type' => 'application/json' }, response.to_json]
end
