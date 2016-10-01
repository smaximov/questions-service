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

  # Return true if the authenticated user is `user`.
  def current_user?(user)
    user_signed_in? && current_user == user
  end

  # If the question has a best answer, return permalink to that answer.
  # Otherwise, return the question path.
  def question_answers_highlight_path(question)
    if question.best_answer_id.present?
      answer_permalink_path(question.best_answer_id)
    else
      question_path(question, anchor: 'answers')
    end
  end
end
