RSpec.describe "Discovery Engine controls" do
  scenario "Viewing Discovery Engine controls" do
    given_several_discovery_engine_controls

    when_i_visit_the_discovery_engine_controls_page

    then_all_discovery_engine_controls_are_displayed
  end

  scenario "Viewing a single Discovery Engine control" do
    given_a_discovery_engine_boost_control

    when_i_visit_the_discovery_engine_controls_page
    and_i_click_on_the_discovery_engine_boost_control

    then_i_can_see_the_details_of_the_discovery_engine_control
  end

  scenario "Creating a new Discovery Engine boost control" do
    when_i_visit_the_discovery_engine_controls_page
    and_i_click_on_the_new_discovery_engine_control_button
    and_i_fill_in_the_discovery_engine_control_form_with_boost_control_details

    then_i_can_see_the_new_discovery_engine_boost_control
  end

  scenario "Creating a new Discovery Engine filter control" do
    when_i_visit_the_discovery_engine_controls_page
    and_i_click_on_the_new_discovery_engine_control_button
    and_i_fill_in_the_discovery_engine_control_form_with_filter_control_details

    then_i_can_see_the_new_discovery_engine_filter_control
  end

  scenario "Editing a Discovery Engine control" do
    given_a_discovery_engine_boost_control

    when_i_visit_the_discovery_engine_controls_page
    and_i_click_on_the_discovery_engine_boost_control
    and_i_click_on_the_edit_button
    and_i_fill_in_the_discovery_engine_control_form_with_new_details

    then_i_can_see_the_updated_discovery_engine_control
  end

  def given_several_discovery_engine_controls
    create(:discovery_engine_filter_control, name: "Control 1")
    create(:discovery_engine_boost_control, name: "Control 2")
  end

  def given_a_discovery_engine_boost_control
    create(:discovery_engine_boost_control, name: "Boost control")
  end

  def when_i_visit_the_discovery_engine_controls_page
    visit "/"
    click_on DiscoveryEngineControl.model_name.human.pluralize
  end

  def and_i_click_on_the_discovery_engine_boost_control
    click_on "Boost control"
  end

  def and_i_click_on_the_new_discovery_engine_control_button
    click_on "New #{DiscoveryEngineControl.model_name.human}"
  end

  def and_i_fill_in_the_discovery_engine_control_form_with_boost_control_details
    fill_in "Name", with: "Boost control"
    check "Active"
    choose "Boost"
    fill_in "Filter", with: 'link: ANY("/example")'
    fill_in "Boost amount", with: 0.13

    click_on "Save"
  end

  def and_i_fill_in_the_discovery_engine_control_form_with_filter_control_details
    fill_in "Name", with: "Filter control"
    check "Active"
    choose "Filter"
    fill_in "Filter", with: 'link: ANY("/example")'

    click_on "Save"
  end

  def and_i_click_on_the_edit_button
    click_on "Edit #{DiscoveryEngineControl.model_name.human}"
  end

  def and_i_fill_in_the_discovery_engine_control_form_with_new_details
    fill_in "Name", with: "Changed control"
    uncheck "Active"
    choose "Filter"
    fill_in "Filter", with: 'link: ANY("/different")'
    fill_in "Boost amount", with: ""

    click_on "Save"
  end

  def then_i_can_see_the_updated_discovery_engine_control
    expect(page).to have_content("Name Changed control")
    expect(page).to have_content("Active false")
    expect(page).to have_content("Action filter")
    expect(page).to have_content("Filter link: ANY(\"/different\")")
    expect(page).to have_content("Boost amount")
  end

  def then_all_discovery_engine_controls_are_displayed
    expect(page).to have_content("Control 1")
    expect(page).to have_content("Control 2")
  end

  def then_i_can_see_the_details_of_the_discovery_engine_control
    expect(page).to have_content("Name Boost control")
    expect(page).to have_content("Active true")
    expect(page).to have_content("Action boost")
  end

  def then_i_can_see_the_new_discovery_engine_boost_control
    expect(page).to have_content("Name Boost control")
    expect(page).to have_content("Active true")
    expect(page).to have_content("Action boost")
    expect(page).to have_content("Filter link: ANY(\"/example\")")
    expect(page).to have_content("Boost amount 0.13")
  end

  def then_i_can_see_the_new_discovery_engine_filter_control
    expect(page).to have_content("Name Filter control")
    expect(page).to have_content("Active true")
    expect(page).to have_content("Action filter")
    expect(page).to have_content("Filter link: ANY(\"/example\")")
  end
end
