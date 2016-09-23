# frozen_string_literal: true

RSpec::Matchers.define :have_errors_on do |attr|
  attr_reader :object_errors, :attr_errors, :attr_has_errors

  # Focus on errors on attr only.
  chain :only do
    @ensure_errors_on_attr_only = true
  end

  # Specifies the exact count of errors to match on attr.
  # This chain doesn't make sense for the negated matcher.
  chain :exactly do |count|
    @errors_count = count
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

  define_method :message_for_exact_error_count do |object|
    message = String.new
    message << "expected #{object.inspect} to have exactly #{@errors_count} error(s) on :username"
    message << ' only' if @ensure_errors_on_attr_only
    message << ", but it has #{@attr_errors.count}"
    append_rest_error_messages(message) if
      @ensure_errors_on_attr_only && attr_errors.count < object_errors.count
    message
  end

  define_method :append_rest_error_messages do |message|
    keys = object_errors.keys.dup
    keys.delete(attr)
    message << "\nerrors on other attributes (#{keys.map(&:inspect).join(', ')}):\n\t"
    message << rest_messages(object_errors)
  end

  # expect(object).to have_errors_on(attr)
  #   means object has errors on attr, but can also have additional errors.
  # expect(object).to have_errors_on(attr).only
  #   means object has errors only on attr.
  # expect(object).to have_errors.on(attr).exactly(5)
  #   means object has exactly 5 errors on attr, and can have other errors.
  # expect(ojbect).to have_errors.on(attr).only.exactly(5)
  #   means object has exactly 5 errors on attr, and no other errors.
  match do |object|
    validate(object)
    if @ensure_errors_on_attr_only
      attr_has_errors? && object_errors.count == attr_errors.count
    else
      attr_has_errors?
    end
  end

  # expect(object).not_to have_errors_on(attr)
  #   means object doesn't have errors on attr.
  # expect(object).not_to have_errors_on(attr).only
  #   means object has errors on attr, but also has additional errors.
  match_when_negated do |object|
    raise ArgumentError, '#exactly is meant to be used with the positive matcher only' unless
      @errors_count.nil?

    return !matches?(object) unless @ensure_errors_on_attr_only
    validate(object)
    attr_has_errors? && attr_errors.count < object_errors.count
  end

  failure_message do |object|
    return message_for_exact_error_count(object) unless @errors_count.nil?

    message = String.new(super())
    message << ', but it has none' if attr_errors.count.zero?
    append_rest_error_messages(message) if
      @ensure_errors_on_attr_only && attr_errors.count < object_errors.count
    message
  end

  failure_message_when_negated do |object|
    return super() + "\nerrors:\n\t" + attr_messages(object.errors) unless
      @ensure_errors_on_attr_only

    message = String.new(super())
    message << "\n\t#{attr.inspect} doesn't have errors" unless attr_has_errors?
    message << "\n\tno other errors except on #{attr.inspect}" unless
      attr_errors.count < object_errors.count
    message
  end

  private

  def attr_has_errors?
    attr_has_errors && attr_errors.count == (@errors_count || attr_errors.count)
  end
end
