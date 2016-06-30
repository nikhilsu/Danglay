# frozen_string_literal: true
class CreateCabpoolsLocalities < ActiveRecord::Migration
  def change
    create_table :cabpools_localities do |t|
      t.belongs_to :cabpool, index: true, foreign_key: true
      t.belongs_to :locality, index: true, foreign_key: true
    end
  end
end
