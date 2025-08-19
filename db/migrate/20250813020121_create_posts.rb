class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:posts)
      create_table :posts do |t|
        t.string :title
        t.text :content
        t.bigint :user_id, null: false

        t.timestamps
      end
    end
  end
end
