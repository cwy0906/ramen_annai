class AddAvgScoreToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :avg_score, :float, :default=> 0.0
    add_column :stores, :comments_count, :integer, :default => 0
  end
end
