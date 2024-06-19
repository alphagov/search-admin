RSpec.describe "Controls" do
  scenario "Viewing controls" do
    given_several_controls

    when_i_visit_the_controls_page

    then_all_controls_are_displayed
  end

  scenario "Viewing a single control" do
    given_a_control

    when_i_go_to_view_the_control

    then_i_can_see_the_details_of_the_control
  end

  scenario "Creating a new control" do
    when_i_visit_the_controls_page
    and_i_choose_to_create_a_new_control
    and_i_submit_the_form_with_valid_details

    then_the_control_has_been_created
    and_i_can_see_its_details
  end

  scenario "Attempting to create a control with invalid data" do
    when_i_visit_the_controls_page
    and_i_choose_to_create_a_new_control
    and_i_submit_the_form_with_invalid_details

    then_the_control_has_not_been_created
    and_i_can_see_what_errors_i_need_to_fix
  end

  scenario "Editing an existing control" do
    given_a_control

    when_i_go_to_view_the_control
    and_i_choose_to_edit_it
    and_i_submit_the_form_with_updated_details

    then_the_control_has_been_updated
    and_i_can_see_the_new_details
  end

  scenario "Attempting to edit a control with invalid data" do
    given_a_control

    when_i_go_to_view_the_control
    and_i_choose_to_edit_it
    and_i_submit_the_form_with_invalid_details

    then_the_control_has_not_been_updated
    and_i_can_see_what_errors_i_need_to_fix
  end

  scenario "Deleting an existing control" do
    given_a_control

    when_i_go_to_view_the_control
    and_i_choose_to_delete_it

    then_the_control_has_been_deleted_locally
    and_i_am_notified_of_the_deletion
  end

  def given_several_controls
    @control1 = create(:control, name: "Control 1")
    @control2 = create(:control, name: "Control 2")
  end

  def given_a_control
    @control = create(
      :control,
      name: "Control",
      active: true,
      boost_amount: 0.42,
      filter: 'foo: ANY("bar")',
    )
  end

  def when_i_visit_the_controls_page
    visit "/"
    click_on "Controls"
  end

  def when_i_go_to_view_the_control
    visit controls_path
    click_on "Control"
  end

  def and_i_choose_to_create_a_new_control
    click_on "New control"
  end

  def and_i_submit_the_form_with_valid_details
    fill_in "Name", with: "New control"
    fill_in "Boost amount", with: 0.42
    fill_in "Filter", with: 'foo: ANY("bar")'
    check "Activate control"
    click_on "Save"
  end

  def and_i_submit_the_form_with_invalid_details
    fill_in "Name", with: ""
    fill_in "Boost amount", with: 42.0
    fill_in "Filter", with: 'foo: ANY("bar")'
    check "Activate control"
    click_on "Save"
  end

  def and_i_choose_to_edit_it
    click_on "Edit"
  end

  def and_i_submit_the_form_with_updated_details
    fill_in "Name", with: "Updated control"
    click_on "Save"
  end

  def and_i_choose_to_delete_it
    click_on "Delete"
  end

  def then_the_control_has_not_been_created
    expect(Control.count).to eq(0)
  end

  def and_i_can_see_what_errors_i_need_to_fix
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Boost amount must be less than or equal to 1.0")
  end

  def then_all_controls_are_displayed
    expect(page).to have_link("Control 1")
    expect(page).to have_link("Control 2")
  end

  def then_i_can_see_the_details_of_the_control
    expect(page).to have_selector("h1", text: "Control")
  end

  def then_the_control_has_been_created
    expect(Control.count).to eq(1)
  end

  def and_i_can_see_its_details
    expect(page).to have_selector("h1", text: "New control")
  end

  def then_the_control_has_been_updated
    expect(@control.reload.display_name).to eq("Updated control")
  end

  def and_i_can_see_the_new_details
    expect(page).to have_selector("h1", text: "Updated control")
  end

  def then_the_control_has_not_been_updated
    expect(@control.reload.display_name).to eq("Control")
  end

  def then_the_control_has_been_deleted_locally
    expect(Control.count).to eq(0)
  end

  def and_i_am_notified_of_the_deletion
    expect(page).to have_content("Control deleted successfully")
  end
end
