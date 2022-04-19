require "test_helper"

class ArticleTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article_type = article_types(:one)
  end

  test "should get index" do
    get article_types_url
    assert_response :success
  end

  test "should get new" do
    get new_article_type_url
    assert_response :success
  end

  test "should create article_type" do
    assert_difference("ArticleType.count") do
      post article_types_url, params: { article_type: {  } }
    end

    assert_redirected_to article_type_url(ArticleType.last)
  end

  test "should show article_type" do
    get article_type_url(@article_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_type_url(@article_type)
    assert_response :success
  end

  test "should update article_type" do
    patch article_type_url(@article_type), params: { article_type: {  } }
    assert_redirected_to article_type_url(@article_type)
  end

  test "should destroy article_type" do
    assert_difference("ArticleType.count", -1) do
      delete article_type_url(@article_type)
    end

    assert_redirected_to article_types_url
  end
end
