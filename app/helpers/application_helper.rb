# frozen_string_literal: true
module ApplicationHelper
  # Render error messages for resource, if any.
  def error_messages_for(resource)
    return if resource.errors.blank?

    render 'shared/error_messages', errors: resource.errors.full_messages
  end
end
