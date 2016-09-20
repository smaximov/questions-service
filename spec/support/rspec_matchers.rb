# frozen_string_literal: true

RSpec::Matchers.define :have_errors_on do |attribute|
  match do |object|
    object.valid?
    !object.errors[attribute].blank?
  end

  failure_message_when_negated do |object|
    super() + "\nErrors:\n\t" + object.errors.full_messages_for(attribute).join("\n\t")
  end
end
