# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create create_answer)

  def new
    @question = current_user.questions.build
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash.now[:success] = t('.success')
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
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user

    if @answer.save
      flash[:success] = t('.success')
      redirect_to @question
    else
      @answers = @question.answers.page(nil)
      render 'show'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :question)
  end

  def answer_params
    params.require(:answer).permit(:answer)
  end
end
