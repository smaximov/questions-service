# frozen_string_literal: true
module ApplicationHelper
  # Render error messages for resource, if any.
  def error_messages_for(resource)
    return if resource.errors.blank?

    render 'shared/error_messages', errors: resource.errors.full_messages
  end

  # Render user's fullname and username.
  def imprint(user)
    content_tag(:span, class: 'imprint') do
      concat content_tag(:strong, user.fullname, class: 'fullname')
      concat ' ('
      concat content_tag(:span, '@' + user.username, class: %w(username small))
      concat ')'
    end
  end
end
