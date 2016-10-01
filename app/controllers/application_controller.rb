# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_current_location, unless: :devise_controller?

  protected

  # Set user's preferred locale trying the following options in order:
  # - :locale url parameter;
  # - "Accept-Language" HTTP header;
  # If all of the above failed, use the default locale.
  def set_locale
    I18n.locale =
      I18n.available_locales.find { |locale| locale == params[:locale].try(:to_sym) } ||
      http_accept_language.compatible_language_from(I18n.available_locales) ||
      I18n.default_locale
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i(username fullname email))
    devise_parameter_sanitizer.permit(:account_update, keys: [:fullname])
  end

  def default_url_options
    { locale: I18n.locale }
  end

  private

  # override the devise helper to store the current location so we can
  # redirect to it after loggin in or out. This override makes signing in
  # and signing up work automatically.
  def store_current_location
    store_location_for(:user, request.url)
  end
end
