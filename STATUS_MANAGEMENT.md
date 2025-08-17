# 文章狀態管理功能

這個應用程式使用 AASM (Acts As State Machine) gem 來管理文章的狀態。

## 狀態類型

文章有三種狀態：

1. **草稿 (Draft)** - 預設狀態，文章尚未發布
2. **已發布 (Published)** - 文章已發布，可以被讀者看到
3. **已刪除 (Deleted)** - 文章已刪除，不會在列表中顯示

## 狀態轉換

### 允許的轉換：

- **草稿 → 已發布**: 使用 `publish!` 方法
- **已發布 → 草稿**: 使用 `unpublish!` 方法
- **草稿 → 已刪除**: 使用 `delete!` 方法
- **已發布 → 已刪除**: 使用 `delete!` 方法
- **已刪除 → 草稿**: 使用 `restore!` 方法

## 使用方法

### 在 Rails Console 中：

```ruby
# 建立新文章（預設為草稿狀態）
post = Post.create(title: "測試文章", content: "內容")

# 檢查狀態
post.draft?      # => true
post.published?  # => false
post.deleted?    # => false

# 發布文章
post.publish!
post.published?  # => true

# 取消發布
post.unpublish!
post.draft?      # => true

# 刪除文章
post.delete!
post.deleted?    # => true

# 恢復文章
post.restore!
post.draft?      # => true
```

### 查詢不同狀態的文章：

```ruby
# 所有非刪除狀態的文章
Post.active

# 所有已發布的文章
Post.published

# 所有草稿文章
Post.drafts
```

## 路由

新增的路由包括：

- `PATCH /posts/:id/publish` - 發布文章
- `PATCH /posts/:id/unpublish` - 取消發布文章
- `PATCH /posts/:id/delete` - 刪除文章
- `PATCH /posts/:id/restore` - 恢復文章

## 視圖功能

### 文章列表頁面：
- 顯示每篇文章的狀態徽章
- 根據狀態顯示不同的操作按鈕
- 只有文章作者可以看到狀態管理按鈕

### 文章詳細頁面：
- 顯示文章狀態
- 提供狀態管理按鈕
- 根據當前狀態顯示可用的操作

## 狀態徽章顏色

- **草稿**: 黃色徽章
- **已發布**: 綠色徽章
- **已刪除**: 紅色徽章

## 注意事項

1. 只有文章作者可以進行狀態管理操作
2. 已刪除的文章不會在文章列表中顯示
3. 狀態轉換是原子操作，失敗時會回滾
4. 所有狀態變更都會記錄在資料庫中
