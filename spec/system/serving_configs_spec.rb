RSpec.describe "Serving configs", type: :system do
  scenario "Viewing serving configs" do
    given_several_serving_configs_exist

    when_i_visit_the_serving_configs_page
    then_i_should_see_all_serving_configs
    and_i_can_click_through_to_a_serving_config
  end

  def given_several_serving_configs_exist
    @live = create(
      :serving_config,
      use_case: :live,
      remote_resource_id: "live-serving-config",
      display_name: "Live serving config",
    )
    @preview = create(
      :serving_config,
      use_case: :preview,
      remote_resource_id: "preview-serving-config",
      display_name: "Preview serving config",
    )
  end

  def when_i_visit_the_serving_configs_page
    visit serving_configs_path
  end

  def then_i_should_see_all_serving_configs
    expect(page).to have_link("Live serving config")
    expect(page).to have_link("Preview serving config")
  end

  def and_i_can_click_through_to_a_serving_config
    click_link "Live serving config"
    expect(page).to have_selector("h1", text: "Live serving config")
  end
end
