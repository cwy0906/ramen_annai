class CreateMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :menus do |t|
      t.references :store, null: false, foreign_key: true
      t.string :item_name, null: false
      t.integer :item_price, null: false
      t.timestamps
    end
  end
end
