# frozen_string_literal: true

class AddCorrectionsCountToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :corrections_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up do
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
