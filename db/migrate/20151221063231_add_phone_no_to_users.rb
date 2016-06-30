# frozen_string_literal: true
class AddPhoneNoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_no, :string
  end
end
