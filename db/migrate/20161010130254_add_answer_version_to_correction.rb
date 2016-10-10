# frozen_string_literal: true

class AddAnswerVersionToCorrection < ActiveRecord::Migration[5.0]
  def change
    add_reference :corrections, :answer_version, null: true, foreign_key: { to_table: :answer_versions }
  end
end
