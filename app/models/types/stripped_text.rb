# frozen_string_literal: true

# Text stripped of surrounding whitespace.
class StrippedText < ActiveRecord::Type::Text
  def cast_value(value)
    value = value.to_s unless value.respond_to?(:strip)
    value.strip
  end
end
