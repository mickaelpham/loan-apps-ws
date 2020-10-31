# frozen_string_literal: true

class LenderList
  RULES = {
    500 => %w[ScroogeMcDuckBank MagicaDeSpellBank],
    750 => %w[ScroogeMcDuckBank BeagleBoysBank GoldieOGiltBank],
    850 => %w[ScroogeMcDuckBank GoldieOGiltBank]
  }.freeze

  def self.for_credit_score(credit)
    RULES.each do |ceiling_score, banks|
      return banks if credit <= ceiling_score
    end

    []
  end
end
