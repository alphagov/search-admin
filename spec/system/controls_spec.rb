RSpec.describe "Controls", type: :system do
  scenario "Viewing controls" do
    given_several_controls_exist

    when_i_visit_the_controls_page
    then_i_should_see_all_controls
    and_i_can_click_through_to_a_control
  end

  def given_several_controls_exist
    @boost = create(:control, :with_boost_action, display_name: "My boost")
    @filter = create(:control, :with_filter_action, display_name: "My filter")
  end

  def when_i_visit_the_controls_page
    visit controls_path
  end

  def then_i_should_see_all_controls
    expect(page).to have_content("My boost Boost")
    expect(page).to have_content("My filter Filter")
  end

  def and_i_can_click_through_to_a_control
    click_link "My boost", match: :first
    expect(page).to have_selector("h1", text: "My boost")
  end
end
