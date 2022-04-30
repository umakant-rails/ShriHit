require "application_system_test_case"

class ArticleTypesTest < ApplicationSystemTestCase
  setup do
    @article_type = article_types(:one)
  end

  test "visiting the index" do
    visit article_types_url
    assert_selector "h1", text: "Article types"
  end

  test "should create article type" do
    visit article_types_url
    click_on "New article type"

    click_on "Create Article type"

    assert_text "Article type was successfully created"
    click_on "Back"
  end

  test "should update Article type" do
    visit article_type_url(@article_type)
    click_on "Edit this article type", match: :first

    click_on "Update Article type"

    assert_text "Article type was successfully updated"
    click_on "Back"
  end

  test "should destroy Article type" do
    visit article_type_url(@article_type)
    click_on "Destroy this article type", match: :first

    assert_text "Article type was successfully destroyed"
  end
end
