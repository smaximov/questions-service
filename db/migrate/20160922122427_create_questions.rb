# frozen_string_literal: true
class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :title, null: false, limit: 50
      t.text :body, null: false
      t.references :author, null: false, index: true

      t.timestamps
    end

    add_foreign_key :questions, :users, column: :author_id
  end
end
