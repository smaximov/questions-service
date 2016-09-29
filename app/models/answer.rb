# frozen_string_literal: true
class Answer < ApplicationRecord
  include Strippable

  ANSWERS_PER_PAGE = 15

  paginates_per ANSWERS_PER_PAGE

  belongs_to :author, class_name: 'User'
  belongs_to :question

  default_scope { order(created_at: :desc) }

  validates :answer, presence: true
  validates :answer, length: 20..5000, allow_blank: true

  strip :answer

  # Determine the page the answer appears on.
  def page
    position = self.class.where('created_at >= ?', created_at).count
    (position.to_f / ANSWERS_PER_PAGE).ceil
  end
end
