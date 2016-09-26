# frozen_string_literal: true
Rails.application.routes.draw do
  def available_locales
    @available_locales ||= /#{I18n.available_locales.join('|')}/
  end

  scope '(:locale)', locale: available_locales do
    root 'home#index'

    devise_for :users

    resources :questions, only: %i(new create show)
  end
end
