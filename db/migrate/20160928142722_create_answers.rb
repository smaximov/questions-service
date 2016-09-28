# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.text :answer, null: false
      t.references :author, null: false, index: true
      t.references :question, null: false, index: true

      t.timestamps
    end

    add_foreign_key :answers, :users, column: :author_id
    add_foreign_key :answers, :questions, column: :question_id
  end
end
