# frozen_string_literal: true

# {include:AnswersWithCorrectionsQuery#results}
class AnswersWithCorrectionsQuery
  # @param answers [ActiveRecord::Relation]
  # @param user [User, nil] the current user.
  def initialize(user, answers)
    @user = user
    @answers = answers
  end

  # Returns answers with their corrections.
  #
  # @note corrections are obtained via {CorrectionsForUserQuery}.
  #
  # @return [Array<AnswerWithCorrections>]
  def results
    relation = @answers
    answers.tap do |object|
      FORWARDED_METHODS.each do |method|
        object.define_singleton_method(method) { relation.public_send(method) }
      end
    end
  end

  FORWARDED_METHODS = %i(total_pages current_page limit_value offset_value last_page?).freeze

  private

  def answers
    corrections_query = CorrectionsForUserQuery.new(@user)
    @answers.map do |answer|
      AnswerWithCorrections.new(answer, corrections_query.results(answer))
    end
  end
end
