RSpec.describe "Controls", type: :system do
  let(:control) do
    instance_double(DiscoveryEngine::ControlClient, create: true, update: true, delete: true)
  end

  before do
    allow(DiscoveryEngine::ControlClient).to receive(:new).and_return(control)
  end

  scenario "Viewing controls" do
    given_several_controls_exist

    when_i_visit_the_controls_page
    then_i_should_see_all_controls
    and_i_can_click_through_to_a_control
  end

  scenario "Managing boost controls" do
    when_i_visit_the_controls_page
    and_i_choose_to_create_a_new_boost_control
    and_i_submit_the_form_with_boost_control_details

    then_my_control_has_been_created
    and_i_can_see_the_boost_control_details

    when_i_choose_to_edit_the_control
    and_i_submit_the_form_with_updated_boost_control_details

    then_the_control_has_been_updated
    and_i_can_see_the_updated_boost_control_details

    when_i_choose_to_delete_the_control
    then_the_control_has_been_deleted
  end

  scenario "Managing filter controls" do
    when_i_visit_the_controls_page
    and_i_choose_to_create_a_new_filter_control
    and_i_submit_the_form_with_filter_control_details

    then_my_control_has_been_created
    and_i_can_see_the_filter_control_details

    when_i_choose_to_edit_the_control
    and_i_submit_the_form_with_updated_filter_control_details

    then_the_control_has_been_updated
    and_i_can_see_the_updated_filter_control_details

    when_i_choose_to_delete_the_control
    then_the_control_has_been_deleted
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

  def and_i_choose_to_create_a_new_boost_control
    click_link "New boost control"
  end

  def and_i_choose_to_create_a_new_filter_control
    click_link "New filter control"
  end

  def and_i_submit_the_form_with_boost_control_details
    fill_in "Name", with: "My boost control"
    fill_in "Filter expression", with: "is_cool = 1"
    fill_in "Boost factor", with: "0.42"
    fill_in "Comment", with: "This is going to be great."

    click_button "Save control"
  end

  def and_i_submit_the_form_with_filter_control_details
    fill_in "Name", with: "My filter control"
    fill_in "Filter expression", with: "is_cool = 1"
    fill_in "Comment", with: "This is going to be great."

    click_button "Save control"
  end

  def then_my_control_has_been_created
    expect(Control.count).to eq(1)
  end

  def and_i_can_see_the_boost_control_details
    expect(page).to have_selector("h1", text: "Boost control My boost control")
    expect(page).to have_content("Name My boost control")
    expect(page).to have_content("Filter expression is_cool = 1")
    expect(page).to have_content("Boost factor 0.42")
  end

  def and_i_can_see_the_filter_control_details
    expect(page).to have_selector("h1", text: "Filter control My filter control")
    expect(page).to have_content("Name My filter control")
    expect(page).to have_content("Filter expression is_cool = 1")
  end

  def when_i_choose_to_edit_the_control
    click_link "Edit control"
  end

  def and_i_submit_the_form_with_updated_boost_control_details
    fill_in "Name", with: "My updated boost control"
    fill_in "Filter expression", with: "is_really_cool = 999"
    fill_in "Boost factor", with: "0.999"
    fill_in "Comment", with: "Now with 999 more BOOST!"

    click_button "Save control"
  end

  def and_i_submit_the_form_with_updated_filter_control_details
    fill_in "Name", with: "My updated filter control"
    fill_in "Filter expression", with: "is_really_cool = 999"
    fill_in "Comment", with: "Now with 999 more FILTER!"

    click_button "Save control"
  end

  def then_the_control_has_been_updated
    expect(page).to have_content("control was successfully updated")
  end

  def and_i_can_see_the_updated_boost_control_details
    expect(page).to have_selector("h1", text: "Boost control My updated boost control")
    expect(page).to have_content("Name My updated boost control")
    expect(page).to have_content("Filter expression is_really_cool = 999")
    expect(page).to have_content("Boost factor 0.999")
  end

  def and_i_can_see_the_updated_filter_control_details
    expect(page).to have_selector("h1", text: "Filter control My updated filter control")
    expect(page).to have_content("Name My updated filter control")
    expect(page).to have_content("Filter expression is_really_cool = 999")
  end

  def when_i_choose_to_delete_the_control
    click_button "Delete control"
  end

  def then_the_control_has_been_deleted
    expect(page).to have_content("control was successfully deleted")
    expect(Control.count).to eq(0)
  end
end
