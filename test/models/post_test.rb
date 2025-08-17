require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @post = @user.posts.build(title: "Test Post", content: "Test content")
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "should have default status as draft" do
    @post.save
    assert @post.draft?
  end

  test "should transition from draft to published" do
    @post.save
    assert @post.draft?
    
    @post.publish!
    assert @post.published?
  end

  test "should transition from published to draft" do
    @post.save
    @post.publish!
    assert @post.published?
    
    @post.unpublish!
    assert @post.draft?
  end

  test "should transition from draft to deleted" do
    @post.save
    assert @post.draft?
    
    @post.delete!
    assert @post.deleted?
  end

  test "should transition from published to deleted" do
    @post.save
    @post.publish!
    assert @post.published?
    
    @post.delete!
    assert @post.deleted?
  end

  test "should transition from deleted to draft" do
    @post.save
    @post.delete!
    assert @post.deleted?
    
    @post.restore!
    assert @post.draft?
  end

  test "active scope should exclude deleted posts" do
    @post.save
    @post.publish!
    
    post2 = @user.posts.create!(title: "Test Post 2", content: "Test content 2")
    post2.delete!
    
    assert_equal 1, Post.active.count
    assert_includes Post.active, @post
    assert_not_includes Post.active, post2
  end

  test "published scope should only include published posts" do
    @post.save
    @post.publish!
    
    post2 = @user.posts.create!(title: "Test Post 2", content: "Test content 2")
    
    assert_equal 1, Post.published.count
    assert_includes Post.published, @post
    assert_not_includes Post.published, post2
  end

  test "drafts scope should only include draft posts" do
    @post.save
    assert @post.draft?
    
    post2 = @user.posts.create!(title: "Test Post 2", content: "Test content 2")
    post2.publish!
    
    assert_equal 1, Post.drafts.count
    assert_includes Post.drafts, @post
    assert_not_includes Post.drafts, post2
  end
end
