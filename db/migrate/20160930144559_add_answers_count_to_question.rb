# frozen_string_literal: true

class AddAnswersCountToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :answers_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          UPDATE questions
             SET answers_count = (SELECT count(*)
                                    FROM answers
                                   WHERE answers.question_id = questions.id)
        SQL
      end
    end
  end
end
