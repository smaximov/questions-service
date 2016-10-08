# frozen_string_literal: true

class AnswerWithCorrections < SimpleDelegator
  def initialize(answer, corrections)
    super(answer)
    @corrections = corrections
  end

  attr_reader :corrections
end
