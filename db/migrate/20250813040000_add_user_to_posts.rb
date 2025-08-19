class AddUserToPosts < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:posts, :user_id)
      add_column :posts, :user_id, :bigint, null: true
      add_foreign_key :posts, :users
    end
  end
end


