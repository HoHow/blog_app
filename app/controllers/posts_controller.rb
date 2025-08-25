class PostsController < ApplicationController
  before_action :set_post, only: [:show]
  
  # 公開文章列表（顯示所有人的已發布文章）
  def index
    @posts = Post.published
    @posts = @posts.tagged_with(params[:tag]) if params[:tag].present?
    @q = @posts.ransack(params[:q])
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
