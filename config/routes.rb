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
    get '/page/:page', to: 'home#index'

    devise_for :users
    get '/users', to: redirect(UrlHelpersRedirector.new_user_registration_path)

    # Questions
    get '/questions/new', to: 'questions#new', as: :new_question
    get '/questions/:id(/page/:page)', to: 'questions#show', as: :question
    post '/questions/new', to: 'questions#create', as: :questions

    # Answers
    post '/questions/:id', to: 'answers#create', as: :question_answers
    get '/answers/:id', to: 'answers#permalink', as: :answer_permalink
    post '/answers/:id/best', to: 'answers#mark_as_best', as: :answer_mark_as_best
    delete '/answers/:id/best', to: 'answers#cancel_best', as: :answer_cancel_best

    # Corrections
    get '/answers/:id/correction', to: 'corrections#new', as: :suggest_correction
    post '/answers/:id/correction', to: 'corrections#create', as: :create_correction
    get '/corrections/:id/accept', to: 'corrections#accepting', as: :accepting_correction
    post '/corrections/:id/accept', to: 'corrections#accept', as: :accept_correction
    get '/corrections/:id/diff', to: 'corrections#diff', as: :correction_diff
  end
end
