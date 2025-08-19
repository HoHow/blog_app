class AddStatusToPosts < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:posts, :status)
      add_column :posts, :status, :string, default: 'draft'
      add_index :posts, :status
    end
  end
end
