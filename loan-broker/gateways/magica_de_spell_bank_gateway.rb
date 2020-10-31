# frozen_string_literal: true

require 'json'

class MagicaDeSpellBankGateway
  ENDPOINT = URI('http://magica-de-spell-bank/evil-loans')

  def quote(credit_score, amount)
    data = request(credit_score, amount)

    {
      bank: 'Magica De Spell Bank',
      interest_rate: data[:interest_rate],
      amount: amount,
      approved: data[:approved]
    }
  end

  private

  def request(credit_score, amount)
    request = Net::HTTP::Post.new(ENDPOINT)
    request.body = { credit_score: credit_score, amount: amount }.to_json

    response = Net::HTTP.start(ENDPOINT.host, ENDPOINT.port) do |http|
      http.request(request)
    end

    raise 'GatewayError' unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body, symbolize_names: true)
  end
end
