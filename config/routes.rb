# frozen_string_literal: true
Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  resources :questions, only: %i(new create show)
  get '/questions', to: redirect('/questions/new')
end
