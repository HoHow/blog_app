module PostsHelper
  # 搜尋表單輔助方法（管理員用）
  def search_form_for_posts
    content_tag :div, class: "search-form mb-4" do
      form_with url: request.path, method: :get, local: true, class: "row g-3" do |form|
        concat(
          content_tag(:div, class: "col-md-4") do
            form.text_field :q_title_cont, 
                           value: params.dig(:q, :title_cont),
                           placeholder: "搜尋標題...",
                           class: "form-control"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-3") do
            form.select :q_status_eq,
                       options_for_select([
                         ['所有狀態', ''],
                         ['草稿', 'draft'],
                         ['已發布', 'published']
                       ], params.dig(:q, :status_eq)),
                       {},
                       class: "form-select"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-3") do
            form.select :q_created_at_gteq,
                       options_for_select([
                         ['所有時間', ''],
                         ['今天', Date.current],
                         ['本週', 1.week.ago.to_date],
                         ['本月', 1.month.ago.to_date]
                       ], params.dig(:q, :created_at_gteq)),
                       {},
                       class: "form-select"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-2") do
            form.submit "搜尋", class: "btn btn-primary w-100"
          end
        )
      end
    end
  end
  
  # 簡化的搜尋表單（訪客用）
  def simple_search_form_for_posts
    content_tag :div, class: "search-form mb-4" do
      form_with url: request.path, method: :get, local: true, class: "row g-3" do |form|
        concat(
          content_tag(:div, class: "col-md-8") do
            form.text_field :q_title_or_content_cont, 
                           value: params.dig(:q, :title_or_content_cont),
                           placeholder: "搜尋標題或內容...",
                           class: "form-control"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-2") do
            form.select :q_created_at_gteq,
                       options_for_select([
                         ['所有時間', ''],
                         ['今天', Date.current],
                         ['本週', 1.week.ago.to_date],
                         ['本月', 1.month.ago.to_date]
                       ], params.dig(:q, :created_at_gteq)),
                       {},
                       class: "form-select"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-2") do
            form.submit "搜尋", class: "btn btn-primary w-100"
          end
        )
      end
    end
  end
  
  # 清除搜尋連結
  def clear_search_link
    link_to "清除搜尋", request.path, class: "btn btn-outline-secondary btn-sm"
  end
  
  # 搜尋結果統計
  def search_results_count
    if @posts.respond_to?(:total_count)
      "找到 #{@posts.total_count} 篇文章"
    else
      "找到 #{@posts.count} 篇文章"
    end
  end
  
  # 進階搜尋表單（包含更多選項）
  def advanced_search_form_for_posts
    content_tag :div, class: "advanced-search-form mb-4" do
      form_with url: request.path, method: :get, local: true, class: "row g-3" do |form|
        concat(
          content_tag(:div, class: "col-md-6") do
            form.text_field :q_title_cont, 
                           value: params.dig(:q, :title_cont),
                           placeholder: "標題包含...",
                           class: "form-control"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-6") do
            form.text_field :q_content_cont, 
                           value: params.dig(:q, :content_cont),
                           placeholder: "內容包含...",
                           class: "form-control"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-3") do
            form.select :q_status_eq,
                       options_for_select([
                         ['所有狀態', ''],
                         ['草稿', 'draft'],
                         ['已發布', 'published'],
                         ['已刪除', 'deleted']
                       ], params.dig(:q, :status_eq)),
                       {},
                       class: "form-select"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-3") do
            form.text_field :q_created_at_gteq, 
                           value: params.dig(:q, :created_at_gteq),
                           placeholder: "建立時間從...",
                           class: "form-control",
                           type: "date"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-3") do
            form.text_field :q_created_at_lteq, 
                           value: params.dig(:q, :created_at_lteq),
                           placeholder: "建立時間到...",
                           class: "form-control",
                           type: "date"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-3") do
            content_tag(:div, class: "d-flex gap-2") do
              concat(form.submit "搜尋", class: "btn btn-primary flex-fill")
              concat(link_to "清除", request.path, class: "btn btn-outline-secondary")
            end
          end
        )
      end
    end
  end
end
