# frozen_string_literal: true

# Text stripped of surrounding whitespace.
class StrippedText < ActiveRecord::Type::Text
  def cast_value(value)
    value.to_s.strip
  end
end
