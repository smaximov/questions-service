# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create)

  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = t('.success')
      redirect_to @question
    else
      render 'new'
    end
  end

  def show
    @question = Question.find(params[:id])
    @answers = question_answers(@question)
    @answer = @question.answers.build if render_answer_form?
  end

  private

  def question_params
    params.require(:question).permit(:title, :question)
  end

  def question_answers(question)
    answers_scope = question.answers.includes(:author, :current_version).page(params[:page])
    AnswersWithCorrectionsQuery.new(current_user, answers_scope).results
  end

  def render_answer_form?
    request.format.html? && user_signed_in?
  end
end
