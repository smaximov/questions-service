# frozen_string_literal: true

class AcceptSampleCorrections < ActiveRecord::Migration[5.0]
  def change
    corrections = Correction.where(answer_version: nil)
                            .where.not(accepted_at: nil)
                            .order(:accepted_at)
    corrections.find_each do |correction|
      correction.accept(AcceptCorrectionForm.from_correction(correction))
    end
  end
end
