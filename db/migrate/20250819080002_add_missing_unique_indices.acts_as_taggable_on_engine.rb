# This migration comes from acts_as_taggable_on_engine (originally 2)
if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class AddMissingUniqueIndices < ActiveRecord::Migration[4.2]; end
else
  class AddMissingUniqueIndices < ActiveRecord::Migration; end
end

AddMissingUniqueIndices.class_eval do
  def self.up
    add_index ActsAsTaggableOn.tags_table, :name, unique: true

    # 安全地移除索引，避免外鍵約束問題
    begin
      remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_taggable_context_idx' if index_exists?(ActsAsTaggableOn.taggings_table, name: 'taggings_taggable_context_idx')
    rescue => e
      puts "Warning: Could not remove taggings_taggable_context_idx index: #{e.message}"
    end
    
    # 添加新的複合唯一索引
    add_index ActsAsTaggableOn.taggings_table,
              [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type],
              unique: true, name: 'taggings_idx'
  end

  def self.down
    remove_index ActsAsTaggableOn.tags_table, :name

    remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_idx'

    # 安全地添加索引
    add_index ActsAsTaggableOn.taggings_table, [:taggable_id, :taggable_type, :context], name: 'taggings_taggable_context_idx' unless index_exists?(ActsAsTaggableOn.taggings_table, name: 'taggings_taggable_context_idx')
  end
end
