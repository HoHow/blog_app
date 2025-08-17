class AddUserToPosts < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:posts, :user_id)
      add_reference :posts, :user, foreign_key: true, null: true
    end
  end
end


