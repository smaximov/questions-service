# frozen_string_literal: true

module Strippable
  extend ActiveSupport::Concern

  module ClassMethods
    # Override setters for each attribute.
    # New setters call :strip on their argument,
    # if the argument responds_to :strip.
    def strip(*attributes)
      class_eval do
        attributes.each do |attribute|
          define_method("#{attribute}=") do |value|
            super(value.try(:strip))
          end
        end
      end
    end
  end
end
