class PostsController < ApplicationController
  before_action :set_post, only: [:show]
  
  # 公開文章列表（顯示所有人的已發布文章）
  def index
    @posts = Post.published
    @posts = @posts.tagged_with(params[:tag]) if params[:tag].present?
    
    # 處理搜尋參數
    search_params = params[:q]&.permit! || {}
    
    # 處理日期參數，確保格式正確
    if search_params[:created_at_gteq].present?
      begin
        search_params[:created_at_gteq] = Date.parse(search_params[:created_at_gteq])
      rescue ArgumentError
        search_params[:created_at_gteq] = nil
      end
    end
    
    if search_params[:created_at_lteq].present?
      begin
        search_params[:created_at_lteq] = Date.parse(search_params[:created_at_lteq])
      rescue ArgumentError
        search_params[:created_at_lteq] = nil
      end
    end
    
    @q = @posts.ransack(search_params)
    @posts = @q.result(distinct: true).order(created_at: :desc)
    @all_tags = Post.published.tag_counts_on(:tags)
  end

  # 公開文章詳情頁面
  def show
  end


  private
  def set_post
    @post = Post.published.find(params[:id])
  end
end
