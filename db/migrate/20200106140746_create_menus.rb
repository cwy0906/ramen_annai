class CreateMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :menus do |t|
      t.references :store, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
