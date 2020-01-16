class DropMenus < ActiveRecord::Migration[6.0]
  def change
    drop_table :menus  
  end
end
