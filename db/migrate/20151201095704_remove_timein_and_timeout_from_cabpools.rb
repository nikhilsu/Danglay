class RemoveTimeinAndTimeoutFromCabpools < ActiveRecord::Migration
  def change
    remove_column :cabpools, :timein
    remove_column :cabpools, :timeout
  end
end
