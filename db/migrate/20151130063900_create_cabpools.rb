class CreateCabpools < ActiveRecord::Migration
  def change
    create_table :cabpools do |t|
      t.string :route
      t.integer :number_of_people
      t.string :timein
      t.string :timeout
      t.references :locality, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
