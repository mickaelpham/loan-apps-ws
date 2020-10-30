# frozen_string_literal: true

class LenderList
  RULES = {
    500 => %w[scrooge-mcduck-bank magica-de-spell-bank],
    750 => %w[scrooge-mcduck-bank beagle-boys-bank],
    850 => %w[scrooge-mcduck-bank goldie-ogilt-bank]
  }.freeze

  def self.for_credit_score(credit)
    RULES.each do |ceiling_score, banks|
      return banks if credit <= ceiling_score
    end

    []
  end
end
