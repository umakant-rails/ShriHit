require "application_system_test_case"

class SaintBioEventsTest < ApplicationSystemTestCase
  setup do
    @saint_bio_event = saint_bio_events(:one)
  end

  test "visiting the index" do
    visit saint_bio_events_url
    assert_selector "h1", text: "Saint bio events"
  end

  test "should create saint bio event" do
    visit saint_bio_events_url
    click_on "New saint bio event"

    fill_in "Author", with: @saint_bio_event.author_id
    fill_in "Event", with: @saint_bio_event.event
    fill_in "Title", with: @saint_bio_event.title
    fill_in "User", with: @saint_bio_event.user_id
    click_on "Create Saint bio event"

    assert_text "Saint bio event was successfully created"
    click_on "Back"
  end

  test "should update Saint bio event" do
    visit saint_bio_event_url(@saint_bio_event)
    click_on "Edit this saint bio event", match: :first

    fill_in "Author", with: @saint_bio_event.author_id
    fill_in "Event", with: @saint_bio_event.event
    fill_in "Title", with: @saint_bio_event.title
    fill_in "User", with: @saint_bio_event.user_id
    click_on "Update Saint bio event"

    assert_text "Saint bio event was successfully updated"
    click_on "Back"
  end

  test "should destroy Saint bio event" do
    visit saint_bio_event_url(@saint_bio_event)
    click_on "Destroy this saint bio event", match: :first

    assert_text "Saint bio event was successfully destroyed"
  end
end
