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
    case user
    when answer.author then corrections_for_author(answer)
    when nil then corrections_for_everyone(answer)
    else corrections_for_rest_users(answer)
    end
  end

  private

  attr_reader :user

  def corrections_for_author(answer)
    answer
      .corrections
      .order(:accepted_at, :created_at)
  end

  def corrections_for_everyone(answer)
    answer
      .corrections
      .where.not(accepted_at: nil)
      .order(:accepted_at)
  end

  def corrections_for_rest_users(answer)
    answer
      .corrections
      .where('author_id = ? OR accepted_at IS NOT NULL', user.id)
      .order(:accepted_at, :created_at)
  end
end
