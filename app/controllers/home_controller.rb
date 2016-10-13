# frozen_string_literal: true
class HomeController < ApplicationController
  include HomeHelper

  before_action :authenticate_user!, if: -> { tabs.mine? }

  def index
    @questions = questions.includes(:best_answer, :author).page(params[:page])
  end

  private

  # Return the appropriate Question collection for to the selected tab.
  def questions
    @questions_tabs ||= {
      mine: -> { current_user.questions },
      unanswered: -> { Question.where(answers_count: 0) }
    }
    @questions_tabs.fetch(tabs.selected, -> { Question }).call
  end
end
