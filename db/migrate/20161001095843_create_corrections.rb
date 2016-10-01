# frozen_string_literal: true

class CreateCorrections < ActiveRecord::Migration[5.0]
  def change
    create_table :corrections do |t|
      t.text :text
      t.references :author, null: false
      t.references :answer, null: false, index: true
      t.datetime :accepted_at, null: true

      t.timestamps
    end

    add_foreign_key :corrections, :users, column: :author_id
    add_foreign_key :corrections, :answers, column: :answer_id
  end
end
