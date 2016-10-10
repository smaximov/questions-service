# frozen_string_literal: true
class CreateAnswerVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_versions do |t|
      t.text :text, null: false

      t.timestamps
    end
  end
end
