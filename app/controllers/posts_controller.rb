class PostsController < ApplicationController
  # 設定文章作者
  before_action :require_login, except: [:public, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :publish, :unpublish, :delete, :restore]
  before_action :authorize_owner!, only: [:edit, :update, :destroy, :publish, :unpublish, :delete, :restore]
  
  # 公用文章頁面（只顯示已發布的文章）
  def public
    @q = Post.published.ransack(params[:q])
    @posts = @q.result(distinct: true).order(created_at: :desc)
  end
  
  # 個人文章列表（需要登入）
  def index
    @q = current_user.posts.active.ransack(params[:q])
    @posts = @q.result(distinct: true).order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "文章建立成功"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "文章更新成功"
    else
      render :edit
    end
  end

  def destroy
    if @post.delete!
      redirect_to posts_path, notice: "文章已刪除"
    else
      redirect_to @post, alert: "無法刪除文章"
    end
  end
  
  def publish
    if @post.publish!
      redirect_to @post, notice: "文章已發布"
    else
      redirect_to @post, alert: "無法發布文章"
    end
  end
  
  def unpublish
    if @post.unpublish!
      redirect_to @post, notice: "文章已取消發布"
    else
      redirect_to @post, alert: "無法取消發布文章"
    end
  end
  
  def delete
    if @post.delete!
      redirect_to posts_path, notice: "文章已刪除"
    else
      redirect_to @post, alert: "無法刪除文章"
    end
  end
  
  def restore
    if @post.restore!
      redirect_to @post, notice: "文章已恢復"
    else
      redirect_to @post, alert: "無法恢復文章"
    end
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end
  def post_params
    params.require(:post).permit(:title, :content)
  end
  def authorize_owner!
    return if @post.user_id == current_user&.id
    redirect_to posts_path, alert: "無權限進行此操作"
  end

end
