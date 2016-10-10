# frozen_string_literal: true

class MoveAnswersDataToAnswerVersions < ActiveRecord::Migration[5.0]
  def change
    Answer.find_each do |answer|
      answer.create_current_version!(text: answer.answer)
      answer.save
    end

    remove_column :answers, :answer
    change_column_null :answers, :current_version_id, false
  end
end
