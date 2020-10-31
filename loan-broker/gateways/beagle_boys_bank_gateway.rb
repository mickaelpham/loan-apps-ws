# frozen_string_literal: true

class BeagleBoysBankGateway
  ENDPOINT = URI('http://beagle-boys-bank/loan')

  def quote(credit_score, amount)
    data = request(credit_score, amount)

    {
      bank: 'Beagle Boys Bank',
      interest_rate: data['interestRate'],
      amount: amount,
      approved: data['approved']
    }
  end

  private

  def request(credit_score, amount)
    request = Net::HTTP::Post.new(ENDPOINT)
    request.body = { 'creditScore' => credit_score, 'amount' => amount }.to_json

    response = Net::HTTP.start(ENDPOINT.host, ENDPOINT.port) do |http|
      http.request(request)
    end

    raise 'GatewayError' unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end
end
