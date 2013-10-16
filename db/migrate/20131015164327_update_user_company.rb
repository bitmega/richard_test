class UpdateUserCompany < ActiveRecord::Migration
  def change
    add_column :users, :company_id, :integer
    add_column :users, :admin, :boolean, :default => false
  end
end
