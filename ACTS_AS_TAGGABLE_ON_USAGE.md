# Acts-as-Taggable-On 標籤功能使用說明

## 概述

Acts-as-Taggable-On 是一個強大的 Ruby gem，為您的部落格應用程式提供了完整的標籤系統功能。

## 功能特色

### ✅ 已實作的功能
- **標籤添加** - 為文章添加多個標籤
- **標籤編輯** - 修改文章的標籤
- **標籤顯示** - 在文章詳情和列表中顯示標籤
- **標籤篩選** - 按標籤篩選文章
- **標籤雲** - 顯示熱門標籤和使用頻率
- **標籤搜尋** - 與 Ransack 整合的標籤搜尋
- **標籤統計** - 顯示每個標籤的文章數量

## 基本使用方法

### 1. 添加標籤

#### 在表單中添加標籤
```erb
<%= f.text_field :tag_list, value: @post.tag_list.join(', '), 
    class: "form-control", 
    placeholder: "請用逗號分隔標籤，例如：Rails, Ruby, 程式設計" %>
```

#### 在 Controller 中允許標籤參數
```ruby
def post_params
  params.require(:post).permit(:title, :content, :tag_list)
end
```

### 2. 在模型中使用標籤

#### 基本設定
```ruby
class Post < ApplicationRecord
  # 啟用標籤功能
  acts_as_taggable_on :tags
  
  # 標籤相關的 scope
  scope :tagged_with_any, ->(tags) { tagged_with(tags, any: true) }
  scope :tagged_with_all, ->(tags) { tagged_with(tags) }
end
```

#### 標籤操作方法
```ruby
# 添加標籤
post.tag_list.add("Ruby", "Rails")
post.save

# 移除標籤
post.tag_list.remove("Ruby")
post.save

# 設定標籤（覆蓋原有標籤）
post.tag_list = "Ruby, Rails, 程式設計"
post.save

# 取得標籤列表
post.tag_list # => ["Ruby", "Rails", "程式設計"]

# 取得標籤字串
post.tag_list.to_s # => "Ruby, Rails, 程式設計"

# 檢查是否有特定標籤
post.tag_list.include?("Ruby") # => true
```

### 3. 標籤查詢

#### 查找有特定標籤的文章
```ruby
# 查找包含 "Ruby" 標籤的文章
Post.tagged_with("Ruby")

# 查找包含 "Ruby" 或 "Rails" 標籤的文章
Post.tagged_with(["Ruby", "Rails"], any: true)

# 查找同時包含 "Ruby" 和 "Rails" 標籤的文章
Post.tagged_with(["Ruby", "Rails"])

# 查找不包含特定標籤的文章
Post.tagged_with("Ruby", exclude: true)
```

#### 標籤統計
```ruby
# 取得所有標籤及其使用次數
Post.tag_counts_on(:tags)

# 取得特定條件下的標籤統計
Post.published.tag_counts_on(:tags)

# 取得最熱門的標籤
Post.tag_counts_on(:tags).order(taggings_count: :desc).limit(10)
```

### 4. 在 Controller 中的應用

#### 標籤篩選
```ruby
def index
  @posts = current_user.posts.active
  @posts = @posts.tagged_with(params[:tag]) if params[:tag].present?
  @q = @posts.ransack(params[:q])
  @posts = @q.result(distinct: true).order(created_at: :desc)
  @all_tags = current_user.posts.active.tag_counts_on(:tags)
end

def public
  @posts = Post.published
  @posts = @posts.tagged_with(params[:tag]) if params[:tag].present?
  @q = @posts.ransack(params[:q])
  @posts = @q.result(distinct: true).order(created_at: :desc)
  @all_tags = Post.published.tag_counts_on(:tags)
end
```

### 5. 在視圖中的應用

#### 顯示標籤
```erb
<!-- 顯示文章標籤 -->
<% if @post.tag_list.any? %>
  <div class="post-tags">
    <strong>標籤：</strong>
    <% @post.tag_list.each do |tag| %>
      <%= link_to tag, public_posts_path(tag: tag), 
          class: "badge bg-primary text-white me-1" %>
    <% end %>
  </div>
<% end %>
```

#### 標籤雲
```erb
<!-- 熱門標籤雲 -->
<% if @all_tags.any? %>
  <div class="tag-cloud">
    <h5>熱門標籤：</h5>
    <% @all_tags.each do |tag| %>
      <%= link_to tag.name, public_posts_path(tag: tag.name), 
          class: "badge bg-secondary", 
          style: "font-size: #{[tag.count * 2 + 8, 16].min}px;" %>
      <span class="text-muted">(<%= tag.count %>)</span>
    <% end %>
  </div>
<% end %>
```

#### 標籤篩選狀態
```erb
<!-- 顯示當前篩選的標籤 -->
<% if params[:tag].present? %>
  <div class="current-tag-filter">
    <span>目前篩選標籤：<strong><%= params[:tag] %></strong></span>
    <%= link_to "清除篩選", posts_path, class: "btn btn-sm btn-outline-secondary" %>
  </div>
<% end %>
```

## 進階功能

### 1. 多種標籤類型

```ruby
class Post < ApplicationRecord
  # 可以設定多種類型的標籤
  acts_as_taggable_on :tags, :skills, :interests, :categories
end

# 使用不同類型的標籤
post.tag_list = "Ruby, Rails"
post.skill_list = "程式設計, 後端開發"
post.category_list = "教學, 技術文章"
```

### 2. 標籤權重和熱度

```ruby
# 取得標籤使用頻率
def tag_cloud_data
  tags = Post.published.tag_counts_on(:tags)
  max_count = tags.maximum(:taggings_count) || 1
  
  tags.map do |tag|
    {
      name: tag.name,
      count: tag.taggings_count,
      weight: (tag.taggings_count.to_f / max_count * 100).round
    }
  end
end
```

### 3. 標籤自動完成

```erb
<!-- 添加標籤自動完成功能 -->
<%= f.text_field :tag_list, 
    data: { 
      tags: Post.tag_counts_on(:tags).pluck(:name).to_json 
    },
    class: "form-control tag-autocomplete" %>

<script>
// 使用 JavaScript 實作自動完成
document.addEventListener('DOMContentLoaded', function() {
  const tagInput = document.querySelector('.tag-autocomplete');
  if (tagInput) {
    const availableTags = JSON.parse(tagInput.dataset.tags);
    // 實作自動完成邏輯
  }
});
</script>
```

### 4. 標籤驗證

```ruby
class Post < ApplicationRecord
  acts_as_taggable_on :tags
  
  # 驗證標籤數量
  validate :validate_tag_count
  
  private
  
  def validate_tag_count
    if tag_list.length > 10
      errors.add(:tag_list, "最多只能有 10 個標籤")
    elsif tag_list.length < 1
      errors.add(:tag_list, "至少需要 1 個標籤")
    end
  end
end
```

### 5. 標籤相關統計

```ruby
# 在 Controller 中取得標籤統計
def dashboard
  @tag_stats = {
    total_tags: ActsAsTaggableOn::Tag.count,
    most_used_tag: Post.tag_counts_on(:tags).order(taggings_count: :desc).first,
    recent_tags: Post.tag_counts_on(:tags).order(created_at: :desc).limit(5),
    my_tag_count: current_user.posts.tag_counts_on(:tags).count
  }
end
```

## 與 Ransack 整合

### 1. 標籤搜尋

```ruby
# 在 Post 模型中加入標籤到可搜尋關聯
def self.ransackable_associations(auth_object = nil)
  ["user", "rich_text_content", "tags", "taggings"]
end

# 搜尋包含特定標籤的文章
@q = Post.ransack(tags_name_cont: "Ruby")
@posts = @q.result(distinct: true)
```

### 2. 複合搜尋

```erb
<!-- 搜尋表單中加入標籤搜尋 -->
<%= form_with url: posts_path, method: :get, local: true do |form| %>
  <%= form.text_field :q_title_cont, placeholder: "搜尋標題..." %>
  <%= form.text_field :q_tags_name_cont, placeholder: "搜尋標籤..." %>
  <%= form.submit "搜尋" %>
<% end %>
```

## 效能優化

### 1. 資料庫索引

```ruby
# 為標籤相關表格添加索引
class AddIndexesToTags < ActiveRecord::Migration[8.0]
  def change
    add_index :tags, :name
    add_index :taggings, [:tag_id, :taggable_id, :taggable_type]
    add_index :taggings, [:taggable_id, :taggable_type]
  end
end
```

### 2. 快取標籤

```ruby
# 使用 Rails 快取機制
def popular_tags
  Rails.cache.fetch("popular_tags", expires_in: 1.hour) do
    Post.published.tag_counts_on(:tags).order(taggings_count: :desc).limit(20)
  end
end
```

### 3. 批次載入

```ruby
# 避免 N+1 查詢
@posts = Post.includes(:tags).published.limit(10)
```

## 常見問題

### 1. 標籤不顯示
- 檢查是否正確設定 `acts_as_taggable_on :tags`
- 確認 `tag_list` 參數已加入 `strong_parameters`
- 檢查資料庫遷移是否正確執行

### 2. 標籤搜尋不準確
- 確認 Ransack 設定中包含 `tags` 關聯
- 檢查搜尋語法是否正確
- 使用 `distinct: true` 避免重複結果

### 3. 效能問題
- 為標籤表格添加適當的索引
- 使用快取機制
- 使用 `includes` 避免 N+1 查詢

## 最佳實踐

### 1. 標籤命名規範
- 使用有意義的標籤名稱
- 避免過於相似的標籤
- 建立標籤管理頁面

### 2. 標籤分類
- 考慮使用不同類型的標籤
- 建立標籤層級結構
- 定期清理無用標籤

### 3. 使用者體驗
- 提供標籤自動完成功能
- 顯示熱門標籤建議
- 實作標籤篩選和搜尋

這個 acts-as-taggable-on 實作為您的部落格提供了完整且強大的標籤系統，讓內容管理和發現變得更加容易！

## 安裝和設定步驟

1. **安裝 gem**：
```bash
bundle install
```

2. **執行遷移**：
```bash
rails db:migrate
```

3. **開始使用**：
現在您可以在文章表單中添加標籤，並在文章列表中看到標籤功能了！

## 標籤功能示例

### 添加標籤
- 在新增/編輯文章時，可以在「標籤」欄位中輸入標籤，用逗號分隔
- 例如：`Rails, Ruby, 程式設計, 教學`

### 瀏覽標籤
- 在文章列表頁面可以看到熱門標籤雲
- 點擊標籤可以篩選相關文章
- 在文章詳情頁面可以看到該文章的所有標籤

### 標籤篩選
- 點擊任何標籤可以篩選包含該標籤的文章
- 支援「清除篩選」功能回到完整列表
