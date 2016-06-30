# frozen_string_literal: true
class CreateCabpools < ActiveRecord::Migration
  def change
    create_table :cabpools do |t|
      t.integer :number_of_people
      t.time :timein
      t.time :timeout

      t.timestamps null: false
    end
  end
end
