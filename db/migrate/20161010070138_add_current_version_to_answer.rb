# frozen_string_literal: true

class AddCurrentVersionToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_reference :answers, :current_version, null: true, foreign_key: { to_table: :answer_versions }
  end
end
