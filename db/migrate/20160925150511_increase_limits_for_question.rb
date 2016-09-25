# frozen_string_literal: true
class IncreaseLimitsForQuestion < ActiveRecord::Migration[5.0]
  def change
    change_column :questions, :title, :string, limit: 200
  end
end
