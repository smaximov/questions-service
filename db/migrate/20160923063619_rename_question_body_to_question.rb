# frozen_string_literal: true

class RenameQuestionBodyToQuestion < ActiveRecord::Migration[5.0]
  def change
    rename_column :questions, :body, :question
  end
end
