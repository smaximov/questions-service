# frozen_string_literal: true

class AddAcceptedCorrectionsCountToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :accepted_corrections_count, :integer, null: false, default: 0

    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          UPDATE answers
             SET accepted_corrections_count = (SELECT count(*)
                                                 FROM corrections
                                                WHERE corrections.answer_id = answers.id
                                                  AND corrections.accepted_at IS NOT NULL)
        SQL
      end
    end
  end
end
