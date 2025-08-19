class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  
  include AASM
  
  aasm column: :status do
    state :draft, initial: true
    state :published
    state :deleted
    
    event :publish do
      transitions from: :draft, to: :published
    end
    
    event :unpublish do
      transitions from: :published, to: :draft
    end
    
    event :delete do
      transitions from: [:draft, :published], to: :deleted
    end
    
    event :restore do
      transitions from: :deleted, to: :draft
    end
  end
  
  # 只顯示非刪除狀態的文章
  scope :active, -> { where.not(status: 'deleted') }
  scope :published, -> { where(status: 'published') }
  scope :drafts, -> { where(status: 'draft') }
  
  # Ransack 可搜尋的屬性
  def self.ransackable_attributes(auth_object = nil)
    ["title", "content", "status", "created_at", "updated_at"]
  end
  
  # Ransack 可搜尋的關聯
  def self.ransackable_associations(auth_object = nil)
    ["user", "rich_text_content"]
  end
end
