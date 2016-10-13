# frozen_string_literal: true
class Answer < ApplicationRecord
  ANSWERS_PER_PAGE = 15

  paginates_per ANSWERS_PER_PAGE

  before_create :create_initial_version

  belongs_to :author, class_name: ::User
  belongs_to :question, counter_cache: true
  # Do I really need this if I already has belongs_to :question?
  # has_one :question, foreign_key: :best_answer_id
  has_many :corrections
  belongs_to :current_version, class_name: ::Answer::Version, optional: true

  default_scope { order(created_at: :desc) }

  validates :answer, presence: true
  validates :answer, length: 20..5000, allow_blank: true

  attribute :answer, :squished_text

  # Determine the page the answer appears on.
  def page
    position = self.class.where('created_at >= ? AND question_id = ?',
                                created_at, question_id).count
    (position.to_f / ANSWERS_PER_PAGE).ceil
  end

  # Mark the answer as the best answer to the corresponding question.
  def mark_as_best
    question.update_attribute(:best_answer, self)
  end

  # Remove the best answer mark, if set.
  def remove_best_mark
    question.update_attribute(:best_answer, nil) if
      question.best_answer == self
  end

  # Check if the answer is the best answer to the corresponding question
  def best?
    question.best_answer == self
  end

  private

  # Create the initial version of the answer.
  def create_initial_version
    return if answer.blank?

    create_current_version!(text: answer)
  end
end
