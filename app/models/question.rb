# frozen_string_literal: true
class Question < ApplicationRecord
  include Strippable

  belongs_to :author, class_name: :User

  validates :title, presence: true
  validates :title, length: { within: 10..50 }

  validates :body, presence: true
  validates :body, length: { within: 20..1000 }

  strip :title
  strip :body
end
