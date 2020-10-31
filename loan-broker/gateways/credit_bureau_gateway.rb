# frozen_string_literal: true

class CreditBureauGateway
  HOST = 'credit-bureau'
  PATH = '/credit-score'

  def self.credit_score(ssn)
    query = URI.encode_www_form(ssn: ssn)
    uri = URI::HTTP.build(host: HOST, path: PATH, query: query)
    body = Net::HTTP.get(uri)

    JSON.parse(body, symbolize_names: true)
  end
end
