# frozen_string_literal: true
class AddTimestampsToCabpoolsLocalitiesTable < ActiveRecord::Migration
  def change
    add_timestamps(:cabpools_localities, null: false)
  end
end
