# frozen_string_literal: true

class Correction < ApplicationRecord
  belongs_to :answer
  belongs_to :author, class_name: 'User'

  validates :text, presence: true
  validates :text, length: 20..500, allow_blank: true

  before_create :set_accepted_time

  attribute :text, :stripped_text

  counter_culture :answer, column_name: ->(model) { "#{model.status}_corrections_count" }

  # Return true if the correction is accepted.
  def accepted?
    accepted_at.present?
  end

  # Return :accepted if the correction is accepted, :pending otherwise.
  def status
    accepted? ? :accepted : :pending
  end

  private

  def set_accepted_time
    self.accepted_at = Time.current if author_id == answer.author_id
  end
end