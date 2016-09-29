# frozen_string_literal: true

class AddBestAnswerToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :best_answer, null: true, foreign_key: { to_table: :answers }
  end
end
