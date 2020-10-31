# frozen_string_literal: true

require_relative 'gateways/beagle_boys_bank_gateway'
require_relative 'gateways/goldie_ogilt_bank_gateway'
require_relative 'gateways/magica_de_spell_bank_gateway'
require_relative 'gateways/scrooge_mcduck_bank_gateway'
require_relative 'lender_list'

class BestQuote
  attr_reader :credit_score, :amount

  def initialize(credit_score, amount)
    @credit_score = credit_score
    @amount = amount
  end

  def call
    quotes = bank_gateways.map { |bank| bank.new.quote(credit_score, amount) }

    quotes
      .filter { |q| q[:approved] }
      .min_by { |q| q[:interest_rate] }
  end

  private

  def bank_gateways
    lender_list.map do |bank_name|
      Object.const_get("#{bank_name}Gateway")
    end
  end

  def lender_list
    LenderList.for_credit_score(credit_score)
  end
end
