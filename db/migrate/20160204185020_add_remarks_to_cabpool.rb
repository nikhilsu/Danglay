# frozen_string_literal: true
class AddRemarksToCabpool < ActiveRecord::Migration
  def change
    add_column :cabpools, :remarks, :string
  end
end
