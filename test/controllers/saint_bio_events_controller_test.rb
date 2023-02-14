require "test_helper"

class SaintBioEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @saint_bio_event = saint_bio_events(:one)
  end

  test "should get index" do
    get saint_bio_events_url
    assert_response :success
  end

  test "should get new" do
    get new_saint_bio_event_url
    assert_response :success
  end

  test "should create saint_bio_event" do
    assert_difference("SaintBioEvent.count") do
      post saint_bio_events_url, params: { saint_bio_event: { author_id: @saint_bio_event.author_id, event: @saint_bio_event.event, title: @saint_bio_event.title, user_id: @saint_bio_event.user_id } }
    end

    assert_redirected_to saint_bio_event_url(SaintBioEvent.last)
  end

  test "should show saint_bio_event" do
    get saint_bio_event_url(@saint_bio_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_saint_bio_event_url(@saint_bio_event)
    assert_response :success
  end

  test "should update saint_bio_event" do
    patch saint_bio_event_url(@saint_bio_event), params: { saint_bio_event: { author_id: @saint_bio_event.author_id, event: @saint_bio_event.event, title: @saint_bio_event.title, user_id: @saint_bio_event.user_id } }
    assert_redirected_to saint_bio_event_url(@saint_bio_event)
  end

  test "should destroy saint_bio_event" do
    assert_difference("SaintBioEvent.count", -1) do
      delete saint_bio_event_url(@saint_bio_event)
    end

    assert_redirected_to saint_bio_events_url
  end
end
