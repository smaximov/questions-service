# frozen_string_literal: true

class AddPreviousVersionToAnswerVersions < ActiveRecord::Migration[5.0]
  def change
    add_reference :answer_versions, :previous_version, null: true, foreign_key: { to_table: :answer_versions }
  end
end
