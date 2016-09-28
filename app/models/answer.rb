# frozen_string_literal: true
class Answer < ApplicationRecord
  include Strippable

  paginates_per 15

  belongs_to :author, class_name: :User
  belongs_to :question

  default_scope { order(created_at: :desc) }

  validates :answer, presence: true
  validates :answer, length: 20..5000, allow_blank: true

  strip :answer
end
