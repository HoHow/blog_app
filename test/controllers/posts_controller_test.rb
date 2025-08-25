require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get show" do
    # 需要一個已發布的文章來測試
    post = posts(:one)
    post.update(status: 'published')
    get post_url(post)
    assert_response :success
  end
end
