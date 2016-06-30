# frozen_string_literal: true
class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :cabpool, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
