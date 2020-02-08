class AddPositionToMenus < ActiveRecord::Migration[6.0]
  def change
    add_column :menus, :position, :integer
  end
end
