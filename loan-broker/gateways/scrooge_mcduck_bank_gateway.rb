# frozen_string_literal: true

require 'json'

class ScroogeMcDuckBankGateway
  ENDPOINT = URI('http://scrooge-mcduck-bank/loans')

  def quote(credit_score, amount)
    data = request(credit_score, amount)

    {
      bank: 'Scrooge McDuck Bank',
      interest_rate: data['InterestRate'],
      amount: amount,
      approved: data['Approved']
    }
  end

  private

  def request(credit_score, amount)
    request = Net::HTTP::Post.new(ENDPOINT)
    request.body = { 'CreditScore' => credit_score, 'Amount' => amount }.to_json

    response = Net::HTTP.start(ENDPOINT.host, ENDPOINT.port) do |http|
      http.request(request)
    end

    raise 'GatewayError' unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end
end
