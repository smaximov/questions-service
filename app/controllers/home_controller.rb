# frozen_string_literal: true
class HomeController < ApplicationController
  include HomeHelper

  before_action :authenticate_user_if_tab_is_mine!

  def index
    collection = case tabs.selected
                 when :mine then current_user.questions
                 else Question
                 end
    @questions = collection.page(params[:page])
  end

  private

  def authenticate_user_if_tab_is_mine!
    return authenticate_user! if tabs.mine?
  end
end
