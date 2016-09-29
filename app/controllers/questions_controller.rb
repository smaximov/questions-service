# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!,
                only: %i(new create create_answer mark_as_best cancel_best)

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
    @answers = @question.answers.page(params[:page])
    @answer = @question.answers.build if user_signed_in?
  end

  def create_answer
    @question = Question.find(params[:question_id])
    @answer = answer_to(@question)

    if @answer.save
      flash[:success] = t('.success')
      redirect_to answer_path(@answer)
    else
      @answers = @question.answers.page(nil)
      render 'show'
    end
  end

  def answer
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

  def question_params
    params.require(:question).permit(:title, :question)
  end

  def answer_params
    params.require(:answer).permit(:answer)
  end

  def answer_to(question)
    answer = question.answers.build(answer_params)
    answer.author = current_user
    answer
  end

  def answer_path(answer)
    page = answer.page
    page = nil if page == 1
    question_path(answer.question, page: page, anchor: "answer-#{answer.id}")
  end
end
