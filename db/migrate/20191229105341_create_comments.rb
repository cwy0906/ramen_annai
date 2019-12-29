class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.integer :visit_count
      t.integer :score
      t.string :visit_time
      t.integer :spend
      t.text :content

      t.timestamps
    end
  end
end
