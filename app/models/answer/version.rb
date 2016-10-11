# frozen_string_literal: true

class Answer
  class Version < ApplicationRecord
    belongs_to :previous_version, class_name: ::Answer::Version, optional: true
  end
end
