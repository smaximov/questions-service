# frozen_string_literal: true

# Text stripped of surrounding whitespace.
class SquishedText < ActiveRecord::Type::Text
  def cast_value(value)
    value.to_s.squish
  end
end
