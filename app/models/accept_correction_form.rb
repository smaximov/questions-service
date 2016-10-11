# frozen_string_literal: true

class AcceptCorrectionForm
  extend ActiveModel::Translation
  include ActiveModel::AttributeAssignment
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_reader :text

  validates :text, presence: true
  validates :text, length: 20..5000, allow_blank: true

  # Create a new AccceptCorrectionForm, prepopulating :text attribute
  # with the correction text appended to the answer's current text.
  #
  # @param correction [Correction]
  def self.from_correction(correction)
    new(text: correction.answer.current_version.text + ' ' + correction.text)
  end

  def initialize(attributes = {})
    assign_attributes(attributes)
  end

  def text=(value)
    @text = SquishedText.new.cast(value)
  end
end
