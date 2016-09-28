# frozen_string_literal: true
class Question < ApplicationRecord
  include Strippable

  paginates_per 10

  default_scope { order(created_at: :desc) }

  belongs_to :author, class_name: 'User'
  has_many :answers

  validates :title, presence: true
  validates :title, length: { within: 10..200 }, allow_blank: true

  validates :question, presence: true
  validates :question, length: { within: 20..5000 }, allow_blank: true

  strip :title
  strip :question
end
