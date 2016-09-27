# frozen_string_literal: true
require 'rspec/matchers/fail_matchers'

RSpec::Matchers.define :have_errors_on do |attr|
  # Match is valid if attr has errors.
  match do |object|
    validate_object(object)
    validate_matcher(object)
    validate_chain_only(object)
    validate_chain_exactly(object)
    validate_chain_message(object)

    valid?
  end

  # Match is valid if attr has no errors.
  match_when_negated do |object|
    raise ArgumentError, '#exactly is meant to be used with the positive matcher only' unless
      @errors_count.nil?

    validate_object(object)
    validate_matcher(object, negated: true) unless chain?
    validate_chain_only(object, negated: true)
    validate_chain_message(object, negated: true)

    valid?
  end

  # Match is valid if only attr has errors.
  # With negated matcher, consider match invalid when
  # attr has no errors or only attr has errors.
  chain :only do
    @ensure_errors_on_attr_only = true
    chain(:only)
  end

  # Match is valid if attr errors count matches the supplied count.
  # Raise ArgumentError when used with negated matcher.
  chain :exactly do |count|
    @errors_count = count
    chain(:exactly)
  end

  # Match is valid if attr contains specific error message.
  #
  # See the following resources on how the message key is
  # converted to the actual message:
  # - ActiveMode::Errors#generate_message
  # - http://guides.rubyonrails.org/i18n.html#error-message-scopes
  # - http://guides.rubyonrails.org/i18n.html#error-message-interpolation
  chain :message do |message, options = {}|
    @message = message
    @message_options = options
    chain(:message)
  end

  failure_message do |object|
    message = String.new(super())
    append_chain_only_message(object, message) unless valid[:only]
    append_chain_exactly_message(object, message) unless valid[:exactly]
    append_chain_message_message(object, message) unless valid[:message]
    message
  end

  failure_message_when_negated do |object|
    message = String.new(super())
    append_chain_only_message(object, message, negated: true) unless valid[:only]
    append_chain_message_message(object, message, negated: true) unless valid[:message]
    message
  end

  define_method :validate_object do |object|
    raise ArgumentError, "#{object.class} doesn't have a #{attr.inspect} attribute" unless
      object.respond_to?(attr)

    object.valid?
  end

  define_method :validate_matcher do |object, negated: false|
    valid[:basic] = if negated
                      object.errors[attr].blank?
                    else
                      !object.errors[attr].blank?
                    end
  end

  define_method :validate_chain_only do |object, negated: false|
    return unless chain?(:only)

    valid[:only] = if negated
                     errors_count = object.errors[attr].count
                     errors_count.nonzero? && object.errors.count > errors_count
                   else
                     object.errors.count == object.errors[attr].count
                   end
  end

  define_method :validate_chain_exactly do |object|
    return unless chain?(:exactly)

    valid[:exactly] = object.errors[attr].count == @errors_count
  end

  define_method :validate_chain_message do |object, negated: false|
    return unless chain?(:message)

    tested_message = object.errors.generate_message(attr, @message, @message_options)
    contains_message = object.errors[attr].include?(tested_message)

    valid[:message] = if negated
                        !contains_message
                      else
                        contains_message
                      end
  end

  define_method :append_chain_only_message do |object, message, negated: false|
    return unless chain?(:only)

    message << if negated
                 if object.errors[attr].count.zero?
                   "\nExpected :#{attr} to have errors"
                 else
                   "\nExpected to have other errors than on :#{attr}"
                 end
               else
                 keys = object.errors.keys - [attr]
                 "\nExpected errors on attr :#{attr} only, got other on #{keys.inspect}"
               end
  end

  define_method :append_chain_exactly_message do |object, message|
    return unless chain?(:exactly)

    message << "\nExpected exactly #{@errors_count} error(s) on :#{attr}, got #{object.errors[attr].count}"
  end

  define_method :append_chain_message_message do |_object, message, negated: false|
    return unless chain?(:message)

    message << if negated
                 "\nExpected :#{attr} not to have error #{@message.inspect}}"
               else
                 "\nExpected :#{attr} to have error #{@message.inspect}}"
               end
  end

  private

  def valid
    @valid ||= Hash.new { true }
  end

  def valid?
    valid.values.all?
  end

  def chain(chain)
    chain_registry[chain] = true
  end

  def chain?(chain = nil)
    if chain.nil?
      !chain_registry.empty?
    else
      chain_registry[chain]
    end
  end

  def chain_registry
    @chain ||= {}
  end
end
