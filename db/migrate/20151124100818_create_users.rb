# frozen_string_literal: true
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :emp_id
      t.string :name
      t.string :email
      t.text :address
      t.references :locality, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
