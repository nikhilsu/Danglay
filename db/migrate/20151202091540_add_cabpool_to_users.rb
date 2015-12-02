class AddCabpoolToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :cabpool, index: true, foreign_key: true
  end
end
