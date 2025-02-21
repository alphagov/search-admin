RSpec.describe "Serving configs", type: :system do
  let(:serving_config_client) do
    instance_double(DiscoveryEngine::ServingConfigClient, update: true)
  end

  before do
    allow(DiscoveryEngine::ServingConfigClient).to receive(:new).and_return(serving_config_client)
  end

  scenario "Viewing serving configs" do
    given_several_serving_configs_exist

    when_i_visit_the_serving_configs_page
    then_i_should_see_all_serving_configs
    and_i_can_click_through_to_a_serving_config
    and_i_can_see_its_attached_controls
  end

  scenario "Managing attached controls for a serving config" do
    given_several_serving_configs_exist
    and_an_unattached_control_exists

    when_i_visit_the_live_serving_config_page
    and_i_choose_to_manage_attached_controls
    and_i_change_the_attached_controls

    then_the_serving_config_has_been_updated
    and_i_should_see_the_updated_serving_config
  end

  def given_several_serving_configs_exist
    @boost_control = create(:control, :with_boost_action, display_name: "My live boost control")
    @filter_control = create(:control, :with_filter_action, display_name: "My live filter control")

    @live = create(
      :serving_config,
      use_case: :live,
      remote_resource_id: "live-serving-config",
      display_name: "Live serving config",
      controls: [@boost_control, @filter_control],
    )
    @preview = create(
      :serving_config,
      use_case: :preview,
      remote_resource_id: "preview-serving-config",
      display_name: "Preview serving config",
    )
  end

  def and_an_unattached_control_exists
    @new_control = create(:control, :with_filter_action, display_name: "My new control")
  end

  def when_i_visit_the_serving_configs_page
    visit serving_configs_path
  end

  def when_i_visit_the_live_serving_config_page
    visit serving_config_path(@live)
  end

  def and_i_choose_to_manage_attached_controls
    click_link "Manage attached controls"
  end

  def and_i_change_the_attached_controls
    check "My new control"
    uncheck "My live boost control"
    click_button "Save attached controls"
  end

  def then_i_should_see_all_serving_configs
    expect(page).to have_link("Live serving config")
    expect(page).to have_link("Preview serving config")
  end

  def and_i_can_click_through_to_a_serving_config
    click_link "Live serving config"
    expect(page).to have_selector("h1", text: "Live serving config")
  end

  def and_i_can_see_its_attached_controls
    expect(page).to have_link("My live boost control")
    expect(page).to have_link("My live filter control")
  end

  def then_the_serving_config_has_been_updated
    expect(@live.reload.controls).to contain_exactly(@new_control, @filter_control)
    expect(serving_config_client).to have_received(:update).with(@live)
  end

  def and_i_should_see_the_updated_serving_config
    expect(page).to have_link("My new control")
    expect(page).to have_link("My live filter control")

    expect(page).not_to have_link("My live boost control")
  end
end
