class FixStoresTableColumnNameRefError < ActiveRecord::Migration[6.0]
  def change
    rename_column :stores, :users_id, :user_id
  end
end
