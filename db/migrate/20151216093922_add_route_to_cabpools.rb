# frozen_string_literal: true
class AddRouteToCabpools < ActiveRecord::Migration
  def change
    add_column :cabpools, :route, :string
  end
end
