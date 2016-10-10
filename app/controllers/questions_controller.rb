# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class QuestionsController < ApplicationController
  before_action :authenticate_user!,
                only: %i(new create create_answer mark_as_best cancel_best
                         suggest_correction create_correction accepting_correction accept_correction)
  before_action :find_correction_and_answer, only: %i(accepting_correction accept_correction)

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

  def create_answer
    @question = Question.find(params[:id])
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

  def suggest_correction
    @answer = Answer.find(params[:id])
    @correction = @answer.corrections.build
    respond_to :js
  end

  def create_correction
    @answer = Answer.find(params[:id])
    @correction = @answer.corrections.build(correction_params)

    respond_to do |format|
      if @correction.save
        format.js
      else
        format.js { render :suggest_correction }
      end
    end
  end

  def accepting_correction
    return head(:unauthorized) unless current_user?(@answer.author)
    @accept_correction_form = AcceptCorrectionForm.from_correction(@correction)
    respond_to :js
  end

  def accept_correction
    return head(:unauthorized) unless current_user?(@answer.author)
    @accept_correction_form = AcceptCorrectionForm.new(accept_correction_form_params)

    respond_to do |format|
      @new_version = @correction.accept(@accept_correction_form)
      if @new_version
        format.js
      else
        format.js { render :accepting_correction }
      end
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :question)
  end

  def answer_params
    params.require(:answer).permit(:answer)
  end

  def correction_params
    params.require(:correction).permit(:text).merge(author_id: current_user.id)
  end

  def accept_correction_form_params
    params.require(:accept_correction_form).permit(:text)
  end

  def answer_to(question)
    answer = question.answers.build(answer_params)
    answer.author = current_user
    answer
  end

  def answer_path(answer)
    page = answer.page
    page = nil if page == 1
    question_path(answer.question, page: page, focused: answer.id, anchor: "answer-#{answer.id}")
  end

  def question_answers(question)
    AnswersWithCorrectionsQuery.new(current_user, question.answers.page(params[:page])).results
  end

  def render_answer_form?
    request.format.html? && user_signed_in?
  end

  def find_correction_and_answer
    @correction = Correction.find(params[:id])
    @answer = @correction.answer
  end
end
