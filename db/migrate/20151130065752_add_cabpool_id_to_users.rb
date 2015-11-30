class AddCabpoolIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cabpool_id, :integer
  end
end
