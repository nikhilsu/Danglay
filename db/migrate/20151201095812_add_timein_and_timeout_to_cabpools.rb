class AddTimeinAndTimeoutToCabpools < ActiveRecord::Migration
  def change
    add_column :cabpools, :timein, :time
    add_column :cabpools, :timeout, :time
  end
end
