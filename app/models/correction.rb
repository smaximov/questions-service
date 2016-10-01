# frozen_string_literal: true

class Correction < ApplicationRecord
  belongs_to :answer
  belongs_to :author, class_name: 'User'

  validates :text, presence: true
  validates :text, length: 20..500, allow_blank: true

  attribute :text, :stripped_text
end
