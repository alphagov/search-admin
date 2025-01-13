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

  def then_all_discovery_engine_controls_are_displayed
    expect(page).to have_content("Control 1")
    expect(page).to have_content("Control 2")
  end

  def then_i_can_see_the_details_of_the_discovery_engine_control
    expect(page).to have_content("Name Boost control")
    expect(page).to have_content("Active true")
    expect(page).to have_content("Action boost")
  end
end
