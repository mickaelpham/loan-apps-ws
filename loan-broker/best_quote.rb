# frozen_string_literal: true

require 'dry/inflector'

require_relative 'lender_list'

class BestQuote
  attr_reader :credit_score, :inflector

  def initialize(credit_score)
    @credit_score = credit_score

    # used to convert from snake_case to (Upper) CamelCase
    @inflector = Dry::Inflector.new
  end

  def exec
    quotes = bank_gateways.map { |bank| bank.quote(credit_score) }

    quotes.min_by { |q| q[:interest_rate] }
  end

  private

  def bank_gateways
    lender_list.map do |bank_name|
      class_name = "#{inflector.camelize(bank_name)}Gateway"

      Object.const_get(class_name)
    end
  end

  def lender_list
    LenderList.for_credit_score(credit_score)
  end
end
