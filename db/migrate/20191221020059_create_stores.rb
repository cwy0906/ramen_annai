class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.references :users, null: false, foreign_key: true
      t.string :tiltle
      t.string :address
      t.string :city
      t.string :district
      t.string :tel
      t.text :promote
      t.text :intro
      t.string :feature
      t.string :opening_hours
      t.string :closed_day
      t.integer :budget
      t.text :memo

      t.timestamps
    end
  end
end
