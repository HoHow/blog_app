# Ransack 搜尋功能使用說明

## 概述

Ransack 是一個強大的搜尋和排序 gem，為您的部落格應用程式提供了完整的搜尋功能。

## 功能特色

### ✅ 已實作的功能
- **標題搜尋** - 搜尋文章標題
- **內容搜尋** - 搜尋文章內容
- **狀態篩選** - 按文章狀態篩選（草稿/已發布/已刪除）
- **時間範圍搜尋** - 按建立時間篩選
- **組合搜尋** - 多條件組合搜尋
- **搜尋結果統計** - 顯示搜尋結果數量
- **清除搜尋** - 一鍵清除搜尋條件

## 搜尋語法說明

### 基本搜尋

#### 1. 標題搜尋
```ruby
# 標題包含特定文字
q_title_cont: "Rails"

# 標題完全匹配
q_title_eq: "完整標題"

# 標題開頭匹配
q_title_start: "開頭"

# 標題結尾匹配
q_title_end: "結尾"
```

#### 2. 內容搜尋
```ruby
# 內容包含特定文字
q_content_cont: "搜尋詞"

# 標題或內容包含文字
q_title_or_content_cont: "搜尋詞"
```

#### 3. 狀態篩選
```ruby
# 狀態等於
q_status_eq: "published"  # 已發布
q_status_eq: "draft"      # 草稿
q_status_eq: "deleted"    # 已刪除

# 狀態不等於
q_status_not_eq: "deleted"
```

#### 4. 時間範圍搜尋
```ruby
# 建立時間大於等於
q_created_at_gteq: "2024-01-01"

# 建立時間小於等於
q_created_at_lteq: "2024-12-31"

# 建立時間範圍
q_created_at_gteq: "2024-01-01"
q_created_at_lteq: "2024-12-31"
```

### 進階搜尋

#### 1. 組合搜尋
```ruby
# 多條件 AND 搜尋
q_title_cont: "Rails"
q_status_eq: "published"
q_created_at_gteq: "2024-01-01"
```

#### 2. 關聯搜尋
```ruby
# 搜尋特定作者的文章
q_user_username_cont: "作者名稱"

# 搜尋作者名稱包含特定文字的文章
q_user_username_cont: "張"
```

## 使用方式

### 1. 管理員搜尋（個人文章列表）

在 `/posts` 頁面，管理員可以使用：
- **標題搜尋** - 搜尋自己的文章標題
- **狀態篩選** - 按文章狀態篩選
- **時間範圍** - 按建立時間篩選

### 2. 訪客搜尋（公用文章列表）

在 `/public` 頁面，訪客可以使用：
- **標題或內容搜尋** - 搜尋已發布文章的標題或內容
- **時間範圍** - 按建立時間篩選

### 3. 進階搜尋

可以使用進階搜尋表單：
```erb
<%= advanced_search_form_for_posts %>
```

## 程式碼實作

### 控制器層面

```ruby
# PostsController
def index
  @q = current_user.posts.active.ransack(params[:q])
  @posts = @q.result(distinct: true).order(created_at: :desc)
end

def public
  @q = Post.published.ransack(params[:q])
  @posts = @q.result(distinct: true).order(created_at: :desc)
end
```

### 模型層面

```ruby
# Post Model
def self.ransackable_attributes(auth_object = nil)
  ["title", "content", "status", "created_at", "updated_at"]
end

def self.ransackable_associations(auth_object = nil)
  ["user", "rich_text_content"]
end
```

### Helper 方法

```ruby
# PostsHelper
def search_form_for_posts
  # 基本搜尋表單
end

def simple_search_form_for_posts
  # 簡化搜尋表單
end

def advanced_search_form_for_posts
  # 進階搜尋表單
end
```

## 搜尋表單範例

### 基本搜尋表單
```erb
<%= search_form_for_posts %>
```

### 簡化搜尋表單
```erb
<%= simple_search_form_for_posts %>
```

### 進階搜尋表單
```erb
<%= advanced_search_form_for_posts %>
```

### 搜尋結果統計
```erb
<%= search_results_count %>
```

### 清除搜尋
```erb
<%= clear_search_link %>
```

## URL 參數範例

### 搜尋標題包含 "Rails"
```
/posts?q[title_cont]=Rails
```

### 搜尋已發布的文章
```
/posts?q[status_eq]=published
```

### 搜尋本週建立的文章
```
/posts?q[created_at_gteq]=2024-01-15
```

### 組合搜尋
```
/posts?q[title_cont]=Rails&q[status_eq]=published&q[created_at_gteq]=2024-01-01
```

## 效能優化

### 1. 資料庫索引
```ruby
# 在遷移檔案中為常用搜尋欄位添加索引
add_index :posts, :title
add_index :posts, :status
add_index :posts, :created_at
add_index :posts, :user_id
```

### 2. 查詢優化
```ruby
# 使用 includes 避免 N+1 查詢
@posts = @q.result(distinct: true)
           .includes(:user, :rich_text_content)
           .order(created_at: :desc)
```

### 3. 分頁
```ruby
# 如果使用 Kaminari 分頁
@posts = @q.result(distinct: true)
           .order(created_at: :desc)
           .page(params[:page])
```

## 安全性

### 1. 白名單機制
只允許搜尋指定的欄位，防止意外暴露敏感資料。

### 2. 參數驗證
Ransack 自動處理 SQL 注入防護。

### 3. 權限控制
不同使用者看到不同的搜尋選項：
- 管理員：可以搜尋所有狀態的文章
- 訪客：只能搜尋已發布的文章

## 自定義搜尋

### 1. 自定義搜尋條件
```ruby
# 在 Post 模型中定義自定義搜尋
ransacker :full_text do |parent|
  Arel::Nodes::SqlLiteral.new(
    "CONCAT(posts.title, ' ', action_text_rich_texts.body)"
  )
end
```

### 2. 自定義排序
```ruby
# 在控制器中加入排序
@posts = @q.result(distinct: true)
           .order(params[:sort] || 'created_at DESC')
```

## 測試搜尋功能

### 在 Rails Console 中測試
```ruby
# 啟動 console
rails console

# 測試搜尋
q = Post.ransack(title_cont: "Rails")
q.result.to_sql  # 查看生成的 SQL
q.result.count   # 查看結果數量

# 測試組合搜尋
q = Post.ransack(title_cont: "Rails", status_eq: "published")
q.result
```

## 常見問題

### 1. 搜尋沒有結果
- 檢查搜尋條件是否正確
- 確認資料庫中有符合條件的資料
- 檢查字符編碼是否正確

### 2. 搜尋效能慢
- 為常用搜尋欄位添加資料庫索引
- 使用 includes 避免 N+1 查詢
- 考慮使用分頁

### 3. 搜尋結果不準確
- 檢查搜尋語法是否正確
- 確認 ransackable_attributes 設定正確
- 檢查資料庫字符編碼

## 擴展功能

### 1. 全文搜尋
可以整合 Elasticsearch 或 PostgreSQL 全文搜尋功能。

### 2. 搜尋建議
可以實作搜尋建議功能，顯示熱門搜尋詞。

### 3. 搜尋歷史
可以記錄使用者的搜尋歷史。

### 4. 搜尋統計
可以統計搜尋詞的使用頻率。

這個 Ransack 實作提供了強大且靈活的搜尋功能，讓您的部落格應用程式更加使用者友善！
