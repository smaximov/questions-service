# frozen_string_literal: true

class Correction < ApplicationRecord
  belongs_to :answer
  belongs_to :author, class_name: ::User
  belongs_to :answer_version, class_name: ::Answer::Version, optional: true

  validates :text, presence: true
  validates :text, length: 20..500, allow_blank: true

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

  # Return correction's text if the correction is pending.
  # Otherwise return the corresponding answer version's text.
  def correction
    accepted? ? answer_version.text : text
  end

  # Accept the given correction.
  #
  # @param accept_correction_form [AcceptCorrectionForm]
  # @return [Answer::Version, nil]
  #   a new answer version if the correction if valid, nil otherwise
  def accept(accept_correction_form)
    if accept_correction_form.valid?
      new_version = create_answer_version(text: accept_correction_form.text,
                                          previous_version: answer.current_version)
      answer.update_attribute(:current_version, new_version)
      self.accepted_at = Time.current
      save
      new_version
    end
  end
end
