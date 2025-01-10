RSpec.describe "Discovery Engine controls" do
  scenario "Viewing Discovery Engine controls" do
    given_several_discovery_engine_controls

    when_i_visit_the_discovery_engine_controls_page

    then_all_discovery_engine_controls_are_displayed
  end

  def given_several_discovery_engine_controls
    create(:discovery_engine_filter_control, name: "Control 1")
    create(:discovery_engine_boost_control, name: "Control 2")
  end

  def when_i_visit_the_discovery_engine_controls_page
    visit "/"
    click_on DiscoveryEngineControl.model_name.human.pluralize
  end

  def then_all_discovery_engine_controls_are_displayed
    expect(page).to have_content("Control 1")
    expect(page).to have_content("Control 2")
  end
end
