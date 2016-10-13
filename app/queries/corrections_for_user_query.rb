# frozen_string_literal: true

# {include:CorrectionsForUserQuery#results}
class CorrectionsForUserQuery
  # @param user [User, nil] the current signed in user.
  def initialize(user)
    @user = user
  end

  # Query answer's corrections as viewn by some user.
  #
  # There are three possible cases.
  # - The user is not signed in - only corrections accepted by
  #   the answer's author are returned.
  # - The user is the answer's author - all corrections are returned.
  # - The user is some other user - corrections accepted by
  #   the answer's author and corrections made by the user are returned.
  # @param answer [Answer]
  #   the answer which corrections are to query.
  def results(answer)
    query_method = case user
                   when answer.author then :corrections_for_author
                   when nil then :corrections_for_everyone
                   else :corrections_for_rest_users
                   end
    __send__(query_method, corrections_scope(answer))
  end

  ONLY_ACCEPTED_ORDER = :accepted_at
  MIXED_ORDER = 'accepted_at ASC NULLS FIRST, created_at DESC'

  private

  attr_reader :user

  def corrections_for_author(scope)
    scope.order(MIXED_ORDER)
  end

  def corrections_for_everyone(scope)
    scope
      .where.not(accepted_at: nil)
      .order(ONLY_ACCEPTED_ORDER)
  end

  def corrections_for_rest_users(scope)
    scope
      .where('author_id = ? OR accepted_at IS NOT NULL', user.id)
      .order(MIXED_ORDER)
  end

  def corrections_scope(answer)
    answer.corrections.includes(:answer_version, :author)
  end
end
