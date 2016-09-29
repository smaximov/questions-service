# frozen_string_literal: true

class UrlHelpersRedirector
  def self.method_missing(method, *args, **kwargs) # rubocop:disable Style/MethodMissing
    new(method, args, kwargs)
  end

  def initialize(url_helper, args, kwargs)
    @url_helper = url_helper
    @args = args
    @kwargs = kwargs
  end

  def call(params, _request)
    url_helpers.public_send(@url_helper, *@args, **@kwargs.merge(locale: params[:locale]))
  end

  private

  def url_helpers
    Rails.application.routes.url_helpers
  end
end

Rails.application.routes.draw do
  def available_locales
    @available_locales ||= /#{I18n.available_locales.join('|')}/
  end

  scope '(:locale)', locale: available_locales do
    root 'home#index'
    get '/page/:page', to: 'home#index', as: ''

    devise_for :users

    resources :questions, only: %i(new create) do
      post '/', to: 'questions#create_answer', as: :answers
    end

    get '/questions/:id(/page/:page)', to: 'questions#show', as: :question

    get '/answers/:id', to: 'questions#answer', as: :answers_permalink

    get '/users', to: redirect(UrlHelpersRedirector.new_user_registration_path)
    get '/questions', to: redirect(UrlHelpersRedirector.new_question_path)
  end
end
