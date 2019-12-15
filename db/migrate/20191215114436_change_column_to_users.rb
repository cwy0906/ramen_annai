class ChangeColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :comment_count, :integer, :default => 0
  end
end
