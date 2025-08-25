class DropActsAsTaggableOnTables < ActiveRecord::Migration[8.0]
  def up
    # 安全地刪除標籤相關表格
    if table_exists?(:taggings)
      drop_table :taggings
    end
    
    if table_exists?(:tags)
      drop_table :tags
    end
  end

  def down
    # 如果需要回滾，重新建立表格
    unless table_exists?(:tags)
      create_table :tags do |t|
        t.string :name
        t.timestamps
      end
    end
    
    unless table_exists?(:taggings)
      create_table :taggings do |t|
        t.references :tag, foreign_key: true
        t.references :taggable, polymorphic: true
        t.references :tagger, polymorphic: true
        t.string :context, limit: 128
        t.datetime :created_at
      end
    end
  end
end
