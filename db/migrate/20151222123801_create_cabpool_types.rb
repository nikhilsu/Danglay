class CreateCabpoolTypes < ActiveRecord::Migration
  def change
    create_table :cabpool_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
