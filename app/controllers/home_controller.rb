# frozen_string_literal: true
class HomeController < ApplicationController
  include HomeHelper

  before_action :authenticate_user_if_tab_is_mine!

  def index
    @questions = questions.page(params[:page])
  end

  private

  def authenticate_user_if_tab_is_mine!
    authenticate_user! if tabs.mine?
  end

  # Return the appropriate Question collection for to the selected tab.
  def questions
    @questions_tabs ||= {
      mine: -> { current_user.questions },
      unanswered: -> { Question.where(answers_count: 0) }
    }
    @questions_tabs.fetch(tabs.selected, -> { Question }).call
  end
end
