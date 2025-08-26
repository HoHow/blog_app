module PostsHelper
  # 搜尋表單輔助方法（管理員用）
  def search_form_for_posts
    content_tag :div, class: "search-form mb-4" do
      form_with url: users_posts_path, method: :get, local: true, class: "row g-3" do |form|
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
            content_tag(:div, class: "d-flex flex-column") do
              concat(
                form.text_field :q_created_at_gteq, 
                               value: format_date_for_input(params.dig(:q, :created_at_gteq)),
                               placeholder: "建立時間從...",
                               class: "form-control mb-1",
                               type: "date"
              )
              concat(
                content_tag(:div, class: "btn-group btn-group-sm") do
                  concat(link_to "今天", users_posts_path(q: build_search_params_with_date(Date.current)), class: "btn btn-outline-secondary")
                  concat(link_to "本週", users_posts_path(q: build_search_params_with_date(1.week.ago.to_date)), class: "btn btn-outline-secondary")
                  concat(link_to "本月", users_posts_path(q: build_search_params_with_date(1.month.ago.to_date)), class: "btn btn-outline-secondary")
                end
              )
            end
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
    content_tag :div, class: "beautiful-search-form" do
      form_with url: request.path, method: :get, local: true do |form|
        concat(
          content_tag(:div, class: "search-input-group") do
            concat(
              content_tag(:div, class: "search-field") do
                concat(
                  content_tag(:div, class: "search-icon") do
                    content_tag(:i, "", class: "fas fa-search")
                  end
                )
                concat(
                  form.text_field :q_title_or_content_cont, 
                                 value: params.dig(:q, :title_or_content_cont),
                                 placeholder: "搜尋標題或內容...",
                                 class: "search-input"
                )
              end
            )
            
            concat(
              content_tag(:div, class: "search-options") do
                concat(
                  content_tag(:div, class: "date-filter") do
                    concat(
                      content_tag(:label, "發布時間", class: "date-label")
                    )
                    concat(
                      form.text_field :q_created_at_gteq, 
                                     value: format_date_for_input(params.dig(:q, :created_at_gteq)),
                                     placeholder: "從...",
                                     class: "date-input",
                                     type: "date"
                    )
                  end
                )
                
                concat(
                  content_tag(:div, class: "quick-filters") do
                    concat(
                      link_to "今天", request.path + "?" + build_search_params_with_date_and_tag(Date.current).to_query, 
                              class: "quick-filter-btn"
                    )
                    concat(
                      link_to "本週", request.path + "?" + build_search_params_with_date_and_tag(1.week.ago.to_date).to_query, 
                              class: "quick-filter-btn"
                    )
                    concat(
                      link_to "本月", request.path + "?" + build_search_params_with_date_and_tag(1.month.ago.to_date).to_query, 
                              class: "quick-filter-btn"
                    )
                  end
                )
              end
            )
            
            concat(
              content_tag(:div, class: "search-actions") do
                form.submit "搜尋", class: "search-submit-btn"
              end
            )
          end
        )
      end
    end
  end
  
  # 清除搜尋連結
  def clear_search_link
    # 保持標籤篩選，只清除搜尋條件
    link_to request.path + (params[:tag].present? ? "?tag=#{params[:tag]}" : ""), 
            class: "clear-search-btn" do
      content_tag(:i, "", class: "fas fa-times") + " 清除搜尋"
    end
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
                           value: format_date_for_input(params.dig(:q, :created_at_gteq)),
                           placeholder: "建立時間從...",
                           class: "form-control",
                           type: "date"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-3") do
            form.text_field :q_created_at_lteq, 
                           value: format_date_for_input(params.dig(:q, :created_at_lteq)),
                           placeholder: "建立時間到...",
                           class: "form-control",
                           type: "date"
          end
        )
        
        concat(
          content_tag(:div, class: "col-md-3") do
            content_tag(:div, class: "d-flex gap-2") do
              concat(form.submit "搜尋", class: "btn btn-primary flex-fill")
              concat(link_to "清除", request.path + (params[:tag].present? ? "?tag=#{params[:tag]}" : ""), class: "btn btn-outline-secondary")
            end
          end
        )
      end
    end
  end

  # 建立包含當前搜尋條件和指定日期的搜尋參數
  def build_search_params_with_date(date)
    current_params = params[:q]&.permit! || {}
    current_params.merge(created_at_gteq: date)
  end
  
  # 建立包含當前搜尋條件、日期和標籤的搜尋參數
  def build_search_params_with_date_and_tag(date)
    current_params = params[:q]&.permit! || {}
    current_params = current_params.merge(created_at_gteq: date)
    if params[:tag].present?
      { q: current_params, tag: params[:tag] }
    else
      { q: current_params }
    end
  end

  # 將日期物件轉換為適合表單輸入的格式 (YYYY-MM-DD)
  def format_date_for_input(date)
    return "" if date.blank?
    
    if date.is_a?(Date)
      date.strftime("%Y-%m-%d")
    elsif date.is_a?(String)
      # 如果是字串，嘗試解析為日期
      begin
        Date.parse(date).strftime("%Y-%m-%d")
      rescue ArgumentError
        date
      end
    else
      ""
    end
  end
end
