# frozen_string_literal: true
class AddUniqueIndexToEmpid < ActiveRecord::Migration
  def change
    add_index :users, :emp_id, unique: true
  end
end
