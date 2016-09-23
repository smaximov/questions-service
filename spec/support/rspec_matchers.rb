# frozen_string_literal: true

RSpec::Matchers.define :have_errors_on do |attr|
  attr_reader :object_errors, :attr_errors, :attr_has_errors
  alias_method :attr_has_errors?, :attr_has_errors

  chain :only do
    @ensure_errors_on_attribute_only = true
  end

  define_method :validate do |object|
    raise ArgumentError, "#{object.class} doesn't have a #{attr.inspect} attribute" unless
      object.respond_to?(attr)

    object.valid?
    check_errors(object)
  end

  define_method :check_errors do |object|
    @object_errors = object.errors
    @attr_errors = object_errors[attr]
    @attr_has_errors = !@attr_errors.blank?
  end

  # Return error messages for attr, joined.
  define_method :attr_messages do |errors|
    errors.full_messages_for(attr).join("\n\t")
  end

  # Return error messages for other attributes, joined.
  define_method :rest_messages do |errors|
    errors
      .reject { |attribute, _| attribute == attr }
      .map { |(attribute, message)| errors.full_message(attribute, message) }
      .join("\n\t")
  end

  # expect(object).to have_errors_on(attr)
  #   means object has errors on attr, but can also have additional errors.
  # expect(object).to have_errors_on(attr).only
  #   means object has errors only on attr.
  match do |object|
    validate(object)
    if @ensure_errors_on_attribute_only
      attr_has_errors? && object_errors.size == attr_errors.size
    else
      attr_has_errors?
    end
  end

  # expect(object).not_to have_errors_on(attr)
  #   means object doesn't have errors on attr.
  # expect(object).not_to have_errors_on(attr).only
  #   means object has errors on attr, but also has additional errors.
  match_when_negated do |object|
    return !matches?(object) unless @ensure_errors_on_attribute_only
    validate(object)
    attr_has_errors? && attr_errors.size < object_errors.size
  end

  failure_message do |object|
    return super() unless @ensure_errors_on_attribute_only
    return super() unless @attr_has_errors

    keys = object.errors.keys.dup
    keys.delete(attr)

    message = String.new(super())
    message << "\nerrors on other attributes (#{keys.map(&:inspect).join(', ')}):\n\t"
    message << rest_messages(object.errors)
    message
  end

  failure_message_when_negated do |object|
    return super() + "\nerrors:\n\t" + attr_messages(object.errors) unless
      @ensure_errors_on_attribute_only

    message = String.new(super())
    message << "\n\t#{attr.inspect} doesn't have errors" unless attr_has_errors?
    message << "\n\tno other errors except on #{attr.inspect}" unless
      attr_errors.size < object_errors.size
    message
  end
end
