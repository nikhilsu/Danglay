class AddApproveDigestToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :approve_digest, :string
  end
end
