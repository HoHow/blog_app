require "test_helper"

class Users::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @post = posts(:one)
    @post.update(user: @user)
    sign_in @user
  end

  test "should get index" do
    get users_posts_url
    assert_response :success
  end

  test "should get show" do
    get users_post_url(@post)
    assert_response :success
  end

  test "should get new" do
    get new_users_post_url
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post users_posts_url, params: { post: { title: "Test Title", content: "Test Content" } }
    end

    assert_redirected_to users_post_url(Post.last)
  end

  test "should get edit" do
    get edit_users_post_url(@post)
    assert_response :success
  end

  test "should update post" do
    patch users_post_url(@post), params: { post: { title: "Updated Title" } }
    assert_redirected_to users_post_url(@post)
  end

  test "should destroy post" do
    assert_difference('Post.count', 0) do # 軟刪除，不會真的減少數量
      delete users_post_url(@post)
    end

    assert_redirected_to users_posts_url
  end

  private

  def sign_in(user)
    session[:user_id] = user.id
  end
end
