class AddCabpoolTypeToCabpools < ActiveRecord::Migration
  def change
    add_reference :cabpools, :cabpool_type, index: true, foreign_key: true
  end
end
