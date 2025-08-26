# Stimulus 使用說明

## 什麼是 Stimulus？

Stimulus 是一個輕量級的 JavaScript 框架，由 Basecamp 開發，專門用於為現有的 HTML 添加交互行為。它遵循 Rails 的"約定優於配置"理念，讓 JavaScript 代碼更加組織化和可維護。

## 重要說明

**現在我們已經成功將預覽功能改為使用 Stimulus 框架，同時確保 ActionText 編輯器正常工作。**

### 當前解決方案
我們已經實現了：
1. 使用 Stimulus 框架管理預覽功能
2. 保持了 ActionText 編輯器的正常運作
3. 提供了模組化和可重用的 JavaScript 代碼

## 主要特點

1. **輕量級**: 不需要重寫整個應用
2. **漸進式**: 可以逐步添加到現有項目中
3. **聲明式**: 使用 HTML 屬性來連接 JavaScript 行為
4. **模組化**: 每個 controller 負責特定的功能

## 核心概念

### 1. Controllers（控制器）
JavaScript 類，包含頁面元素的行為邏輯。

### 2. Targets（目標）
在 controller 中引用的 DOM 元素。

### 3. Actions（動作）
用戶交互（如點擊、提交）觸發的方法。

### 4. Values（值）
從 HTML 傳遞到 controller 的數據。

## 本次改動說明

### 原始代碼問題
```javascript
// 原始代碼使用傳統的 DOM 操作
document.addEventListener("DOMContentLoaded", function() {
  const form = document.querySelector("form");
  const titleInput = form.querySelector('input[name="post[title]"]');
  // ... 更多 DOM 查詢和事件監聽器
});
```

**問題：**
- 代碼混雜在 ERB 模板中
- 使用 ID 選擇器，難以重用
- 事件監聽器管理複雜
- 難以測試和維護

### Stimulus 解決方案

#### 1. Controller 文件 (`app/javascript/controllers/preview_controller.js`)
```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "dialog", "title", "content", "openBtn", "closeBtn", "closeBtn2"]
  static values = { 
    titleSelector: { type: String, default: 'input[name="post[title]"]' },
    contentSelector: { type: String, default: 'trix-editor' }
  }

  open() {
    // 打開預覽模態框的邏輯
  }

  close() {
    // 關閉預覽模態框的邏輯
  }

  closeOnBackground(event) {
    // 點擊背景關閉的邏輯
  }
}
```

#### 2. HTML 模板改動
```erb
<!-- 原始代碼 -->
<button type="button" id="open-preview" class="btn btn-secondary">預覽</button>
<div id="preview-modal" class="modal">...</div>

<!-- Stimulus 版本 -->
<div data-controller="preview">
  <button type="button" data-preview-target="openBtn" data-action="click->preview#open" class="btn btn-secondary">預覽</button>
  <div data-preview-target="modal" class="modal" data-action="click->preview#closeOnBackground">...</div>
</div>
```

## 語法說明

### 1. Controller 連接
```html
<div data-controller="preview">
  <!-- 這個 div 內的所有元素都可以被 preview controller 控制 -->
</div>
```

### 2. Target 定義
```html
<!-- 在 HTML 中定義 target -->
<button data-preview-target="openBtn">預覽</button>

<!-- 在 JavaScript 中訪問 -->
this.openBtnTarget // 獲取單個元素
this.openBtnTargets // 獲取所有匹配的元素
```

### 3. Action 綁定
```html
<!-- 點擊時調用 preview controller 的 open 方法 -->
<button data-action="click->preview#open">預覽</button>

<!-- 多個事件 -->
<button data-action="click->preview#open keydown->preview#handleKeydown">預覽</button>
```

### 4. Value 傳遞
```html
<!-- 在 HTML 中設置值 -->
<div data-controller="preview" data-preview-title-selector-value="input[name='post[title]']">

<!-- 在 JavaScript 中訪問 -->
this.titleSelectorValue
```

## 優勢

### 1. 更好的組織性
- JavaScript 邏輯集中在 controller 文件中
- HTML 和 JavaScript 通過聲明式屬性連接

### 2. 可重用性
- 同一個 controller 可以在多個頁面使用
- 不需要重複編寫 DOM 查詢代碼

### 3. 可測試性
- Controller 是純 JavaScript 類，易於單元測試
- 可以模擬 DOM 事件和狀態

### 4. 可維護性
- 代碼結構清晰，職責分離
- 遵循 Rails 的約定

## 安裝和設置

### 1. 添加 Gem
```ruby
# Gemfile
gem "stimulus-rails"
```

### 2. 安裝
```bash
bundle install
rails stimulus:install
```

### 3. 配置 application.js
```javascript
import { Application } from "@hotwired/stimulus"
import { registerControllers } from "stimulus-vite-helpers"

const application = Application.start()
const controllers = import.meta.globEager("./**/*_controller.js")
registerControllers(application, controllers)
```

## 最佳實踐

### 1. 命名約定
- Controller 文件名：`snake_case_controller.js`
- Controller 類名：`PascalCase`
- Target 名稱：`camelCase`

### 2. 職責分離
- 每個 controller 只負責一個功能
- 避免在 controller 中處理業務邏輯

### 3. 錯誤處理
```javascript
connect() {
  if (!this.hasModalTarget) {
    console.warn("Preview controller: modal target not found")
  }
}
```

### 4. 生命週期管理
```javascript
disconnect() {
  // 清理事件監聽器、定時器等
  clearTimeout(this.timeoutId)
}
```

## 常見模式

### 1. 模態框模式
```javascript
// 顯示/隱藏模態框
show() {
  this.modalTarget.classList.remove("hidden")
}

hide() {
  this.modalTarget.classList.add("hidden")
}
```

### 2. 表單驗證模式
```javascript
// 實時驗證
validate() {
  const isValid = this.inputTarget.value.length > 0
  this.submitTarget.disabled = !isValid
}
```

### 3. 數據綁定模式
```javascript
// 同步數據
sync() {
  this.outputTarget.textContent = this.inputTarget.value
}
```

## 完整的 Stimulus 實現方案

### 1. 安裝 Stimulus
```bash
# 添加 gem
gem "stimulus-rails"

# 安裝
bundle install
rails stimulus:install
```

### 2. 配置 importmap
```ruby
# config/importmap.rb
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
```

### 3. 配置 application.js
```javascript
// app/javascript/application.js
import "@hotwired/turbo-rails"
import "trix"
import "@rails/actiontext"
import "@hotwired/stimulus-loading"
```

### 4. 創建 Controller
```javascript
// app/javascript/controllers/preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "dialog", "title", "content", "openBtn", "closeBtn", "closeBtn2"]
  static values = { 
    titleSelector: { type: String, default: 'input[name="post[title]"]' },
    contentSelector: { type: String, default: 'trix-editor' }
  }

  open() {
    const titleInput = document.querySelector(this.titleSelectorValue)
    const contentEditor = document.querySelector(this.contentSelectorValue)

    if (this.hasTitleTarget && titleInput) {
      this.titleTarget.textContent = titleInput.value || ""
    }
    
    if (this.hasContentTarget && contentEditor) {
      this.contentTarget.innerHTML = contentEditor.value || ""
    }

    this.modalTarget.style.display = 'flex'
    this.modalTarget.setAttribute('aria-hidden', 'false')
  }

  close() {
    this.modalTarget.style.display = 'none'
    this.modalTarget.setAttribute('aria-hidden', 'true')
  }

  closeOnBackground(event) {
    if (!this.dialogTarget.contains(event.target)) {
      this.close()
    }
  }
}
```

### 5. 更新視圖
```erb
<!-- app/views/users/posts/new.html.erb -->
<div data-controller="preview">
  <%= form_with model: @post, local: true do |f| %>
    <!-- 表單內容 -->
  <% end %>

  <button type="button" data-preview-target="openBtn" data-action="click->preview#open" class="btn btn-secondary">預覽</button>

  <div data-preview-target="modal" class="modal" data-action="click->preview#closeOnBackground">
    <!-- 模態框內容 -->
  </div>
</div>
```

## 故障排除

### ActionText 編輯器無法輸入
如果遇到 ActionText 編輯器無法輸入的問題：

1. **檢查 JavaScript 載入順序**
   ```javascript
   // 確保 Trix 在 Stimulus 之前載入
   import "trix"
   import "@rails/actiontext"
   import "@hotwired/stimulus-loading"
   ```

2. **避免 DOM 衝突**
   - 確保 Stimulus controller 不會干擾 Trix 編輯器
   - 使用 `data-action` 而不是直接的事件監聽器

3. **檢查 CSS 衝突**
   - 確保沒有 CSS 規則影響編輯器的可點擊性
   - 檢查 z-index 設置



## 總結

Stimulus 提供了一種優雅的方式來為 Rails 應用添加 JavaScript 交互，特別適合：

- 現有 Rails 應用的漸進式改進
- 需要模組化和可重用 JavaScript 代碼的項目
- 遵循 Rails 約定的開發團隊

通過這次改動，我們將原本混雜在 ERB 模板中的 JavaScript 代碼重構為結構化的 Stimulus controller，提高了代碼的可維護性和可重用性。

### 當前狀態
我們已經成功將預覽功能改為使用 Stimulus 框架，實現了：
- ✅ 模組化的 JavaScript 代碼
- ✅ 聲明式的 HTML 屬性
- ✅ 可重用的 controller 邏輯
- ✅ 與 ActionText 編輯器的完美兼容

這個實現展示了如何在 Rails 應用中正確使用 Stimulus 來增強現有的 HTML 功能。
