# frozen_string_literal: true

class CorrectionsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create accepting accept)
  before_action :find_correction_and_answer, only: %i(accepting accept diff)
  before_action :authorize_answer_author, only: %i(accepting accept)

  def new
    @answer = Answer.find(params[:id])
    @correction = @answer.corrections.build
    respond_to :js
  end

  def create
    @answer = Answer.find(params[:id])
    @correction = @answer.corrections.build(correction_params)

    respond_to do |format|
      if @correction.save
        format.js
      else
        format.js { render :new }
      end
    end
  end

  def accepting
    @accept_correction_form = AcceptCorrectionForm.from_correction(@correction)
    respond_to :js
  end

  def accept
    @accept_correction_form = AcceptCorrectionForm.new(accept_correction_form_params)

    respond_to do |format|
      @new_version = @correction.accept(@accept_correction_form)
      if @new_version
        format.js
      else
        format.js { render :accepting }
      end
    end
  end

  def diff
    @correction_version = @correction.answer_version
    @previous_version = @correction_version.previous_version
    respond_to :js
  end

  private

  def authorize_answer_author
    raise UnauthorizedError unless current_user?(@answer.author)
  end

  def correction_params
    params.require(:correction).permit(:text).merge(author_id: current_user.id)
  end

  def accept_correction_form_params
    params.require(:accept_correction_form).permit(:text)
  end

  def find_correction_and_answer
    @correction = Correction.find(params[:id])
    @answer = @correction.answer
  end
end
