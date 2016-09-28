# frozen_string_literal: true

module AssociationMatchers
  ASSOCIATIONS_MAP = { belongs_to: :belong_to,
                       has_many: :have_many,
                       has_one: :have_one,
                       has_and_belongs_to_many: :have_and_belong_to_many }.freeze

  ASSOCIATIONS_MAP.each do |type, matcher_name|
    define_method(matcher_name) do |attribute|
      Matcher.new(described_class, matcher_name, type, attribute)
    end
  end

  class Matcher
    def self.option_chain(option)
      define_method(option) do |value|
        chain_desc << "#{option} #{value.inspect}"
        options[option] = value
        self
      end
    end

    def initialize(model, matcher_name, type, attribute)
      @matcher_name = matcher_name
      @model = model
      @type = type
      @attribute = attribute
    end

    def matches?(_target)
      return false if @model.nil? || !@model.is_a?(Class)

      @reflection = @model.reflect_on_association(@attribute)
      return false if @reflection.nil?

      @reflection.macro == @type && options_match?
    end

    def description
      desc = String.new("#{@matcher_name.to_s.tr('_', ' ')} :#{@attribute}")
      desc << " with #{chain_desc.join(', ')}" unless chain_desc.blank?
      desc
    end

    def failure_message
      message = String.new("expected #{@model.inspect} to #{description}")
      message << "\n\tunknown association #{@attribute.inspect}" if @reflection.nil?
      @mismatched_options.each do |key, (actual, expected)|
        message << "\n\texpected #{key} to equal #{expected.inspect}, but it is #{actual.inspect}"
      end
      message
    end

    option_chain :class_name
    option_chain :foreign_key

    private

    def options
      @options ||= {}
    end

    def chain_desc
      @chain_desc ||= []
    end

    def options_match?
      options.all? { |key, expected| matches_actual?(key, expected) }
    end

    def matches_actual?(key, expected)
      @mismatched_options ||= {}

      actual = @reflection.options[key]
      matches = actual == expected

      @mismatched_options[key] = [actual, expected] unless matches

      matches
    end
  end
end

RSpec.configure do |config|
  config.include AssociationMatchers
end
