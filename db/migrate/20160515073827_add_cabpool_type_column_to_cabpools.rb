# frozen_string_literal: true
class AddCabpoolTypeColumnToCabpools < ActiveRecord::Migration
  def change
    add_column :cabpools, :cabpool_type, :integer
  end
end
