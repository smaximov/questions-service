# frozen_string_literal: true
class Question < ApplicationRecord
  include Strippable

  belongs_to :author, class_name: :User

  validates :title, presence: true
  validates :title, length: { within: 10..50 }, allow_nil: true

  validates :question, presence: true
  validates :question, length: { within: 20..1000 }, allow_nil: true

  strip :title
  strip :question
end
