# frozen_string_literal: true

class AddPendingCorrectionsCountToAnswer < ActiveRecord::Migration[5.0]
  def change
    remove_column :answers, :corrections_count
    add_column :answers, :pending_corrections_count, :integer, null: false, default: 0

    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          UPDATE answers
             SET pending_corrections_count = (SELECT count(*)
                                                FROM corrections
                                               WHERE corrections.answer_id = answers.id
                                                 AND corrections.accepted_at IS NULL)
        SQL
      end

      dir.down do
        execute <<-SQL.squish
          UPDATE answers
             SET corrections_count = (SELECT count(*)
                                        FROM corrections
                                       WHERE corrections.answer_id = answers.id)
        SQL
      end
    end
  end
end
