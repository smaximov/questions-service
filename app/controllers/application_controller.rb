# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

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
    devise_parameter_sanitizer.permit(:sign_up, keys: %i(username fullname))
    devise_parameter_sanitizer.permit(:account_update, keys: [:fullname])
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
