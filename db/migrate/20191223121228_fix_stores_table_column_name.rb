class FixStoresTableColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :stores, :tiltle, :title
  end
end
