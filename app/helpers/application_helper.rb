# frozen_string_literal: true
module ApplicationHelper
  # Render error messages for resource, if any.
  def error_messages_for(resource)
    return if resource.errors.blank?

    render 'shared/error_messages', resource: resource
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

  # Display/Provide page title.
  def page_title(title = nil)
    if title.nil?
      sub_title = content_for(:title).try do |t|
        t.truncate(50) + ' - '
      end
      "#{sub_title}#{t('shared.app.name')}"
    else
      provide(:title, title)
    end
  end

  # Return link to the current page in an alternative locale.
  def change_locale_link(locale)
    link_to t(locale, scope: %i(shared locale)), url_for(locale: locale)
  end

  def relative_time_tag(time)
    timeago_tag(time, format: :long, class: 'time')
  end
end
