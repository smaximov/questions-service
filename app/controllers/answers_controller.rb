# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i(create mark_as_best cancel_best)

  def create
    @question = Question.find(params[:id])
    @answer = @question.answers.build(answer_params)

    if @answer.save
      flash[:success] = t('.success')
      redirect_to answer_path(@answer)
    else
      @answers = @question.answers.page(nil)
      render 'questions/show'
    end
  end

  def permalink
    answer = Answer.find(params[:id])
    redirect_to answer_path(answer)
  end

  def mark_as_best
    answer = Answer.find(params[:id])
    return redirect_to question_path(answer.question) unless
      current_user?(answer.question.author)

    answer.mark_as_best
    redirect_to answer_path(answer)
  end

  def cancel_best
    answer = Answer.find(params[:id])
    return redirect_to question_path(answer.question) unless
      current_user?(answer.question.author)

    answer.remove_best_mark
    redirect_to question_path(answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:answer).merge(author_id: current_user.id)
  end

  def answer_path(answer)
    page = answer.page
    page = nil if page == 1
    question_path(answer.question, page: page, focused: answer.id, anchor: "answer-#{answer.id}")
  end
end
