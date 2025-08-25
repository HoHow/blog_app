class Users::PostsController < ApplicationController
  before_action :require_login
  before_action :set_post, only: [:show, :edit, :update, :destroy, :publish, :unpublish, :delete, :restore]
  before_action :authorize_owner!, only: [:edit, :update, :destroy, :publish, :unpublish, :delete, :restore]
  
  # 當前用戶的文章列表
  def index
    @posts = current_user.posts.active
    @posts = @posts.tagged_with(params[:tag]) if params[:tag].present?
    @q = @posts.ransack(params[:q])
    @posts = @q.result(distinct: true).order(created_at: :desc)
    @all_tags = current_user.posts.active.tag_counts_on(:tags)
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to users_post_path(@post), notice: "文章建立成功"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to users_post_path(@post), notice: "文章更新成功"
    else
      render :edit
    end
  end

  def destroy
    if @post.delete!
      redirect_to users_posts_path, notice: "文章已刪除"
    else
      redirect_to users_post_path(@post), alert: "無法刪除文章"
    end
  end
  
  def publish
    if @post.publish!
      redirect_to users_post_path(@post), notice: "文章已發布"
    else
      redirect_to users_post_path(@post), alert: "無法發布文章"
    end
  end
  
  def unpublish
    if @post.unpublish!
      redirect_to users_post_path(@post), notice: "文章已取消發布"
    else
      redirect_to users_post_path(@post), alert: "無法取消發布文章"
    end
  end
  
  def delete
    if @post.delete!
      redirect_to users_posts_path, notice: "文章已刪除"
    else
      redirect_to users_post_path(@post), alert: "無法刪除文章"
    end
  end
  
  def restore
    if @post.restore!
      redirect_to users_post_path(@post), notice: "文章已恢復"
    else
      redirect_to users_post_path(@post), alert: "無法恢復文章"
    end
  end

  private
  
  def set_post
    @post = current_user.posts.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:title, :content, :tag_list)
  end
  
  def authorize_owner!
    return if @post.user_id == current_user.id
    redirect_to users_posts_path, alert: "無權限進行此操作"
  end
end
