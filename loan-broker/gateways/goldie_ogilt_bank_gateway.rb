# frozen_string_literal: true

class GoldieOGiltBankGateway
  ENDPOINT = URI('http://goldie-ogilt-bank/klondike-loans')

  def quote(credit_score, amount)
    data = request(credit_score, amount)

    {
      bank: "Goldie O'Gilt Bank",
      interest_rate: data['interest_rate'],
      amount: amount,
      approved: data['approved']
    }
  end

  private

  def request(_credit_score, amount)
    request = Net::HTTP::Post.new(ENDPOINT)
    request['Content-Type'] = 'application/json'
    request.body = { 'amount' => amount }.to_json

    response = Net::HTTP.start(ENDPOINT.host, ENDPOINT.port) do |http|
      http.request(request)
    end

    raise 'GatewayError' unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end
end
