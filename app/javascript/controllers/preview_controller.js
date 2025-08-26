import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "dialog", "title", "content", "openBtn", "closeBtn", "closeBtn2"]
  static values = { 
    titleSelector: { type: String, default: 'input[name="post[title]"]' },
    contentSelector: { type: String, default: 'trix-editor' }
  }

  connect() {
    // 當 controller 連接到 DOM 時執行
    console.log("Preview controller connected")
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
