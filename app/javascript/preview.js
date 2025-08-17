// 預覽功能
document.addEventListener("DOMContentLoaded", function() {
  console.log("Preview.js loaded");
  
  // 檢查是否在正確的頁面
  const previewBtn = document.getElementById('open-preview');
  if (!previewBtn) {
    console.log("Not on preview page");
    return;
  }
  
  console.log("Preview button found, setting up event listener");
  
  previewBtn.addEventListener('click', function(e) {
    e.preventDefault();
    console.log("Preview button clicked!");
    
    const form = document.querySelector("form");
    const titleInput = form.querySelector('input[name="post[title]"]');
    const contentEditor = form.querySelector('trix-editor');
    const modal = document.getElementById('preview-modal');
    const previewTitle = modal.querySelector('.preview-title');
    const previewContent = modal.querySelector('.preview-content');
    
    console.log("Elements:", {
      titleInput: titleInput?.value,
      contentEditor: contentEditor?.value,
      modal: !!modal
    });
    
    // 設定預覽內容
    if (previewTitle && titleInput) {
      previewTitle.textContent = titleInput.value || "無標題";
    }
    
    if (previewContent && contentEditor) {
      previewContent.innerHTML = contentEditor.value || "無內容";
    }
    
    // 顯示模態視窗
    modal.style.display = 'flex';
    modal.setAttribute('aria-hidden', 'false');
  });
  
  // 關閉按鈕
  const closeBtn = document.getElementById('close-preview');
  const closeBtn2 = document.getElementById('close-preview-2');
  const modal = document.getElementById('preview-modal');
  const dialog = modal.querySelector('.modal-dialog');
  
  if (closeBtn) {
    closeBtn.addEventListener('click', function() {
      modal.style.display = 'none';
      modal.setAttribute('aria-hidden', 'true');
    });
  }
  
  if (closeBtn2) {
    closeBtn2.addEventListener('click', function() {
      modal.style.display = 'none';
      modal.setAttribute('aria-hidden', 'true');
    });
  }
  
  // 點擊背景關閉
  modal.addEventListener('click', function(e) {
    if (!dialog.contains(e.target)) {
      modal.style.display = 'none';
      modal.setAttribute('aria-hidden', 'true');
    }
  });
});
