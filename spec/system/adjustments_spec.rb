RSpec.describe "Adjustments", type: :system do
  scenario "Viewing adjustments" do
    given_several_adjustments_exist
    when_i_visit_the_adjustments_page
    then_i_should_see_all_the_adjustments
    and_i_can_click_through_to_see_more_details
  end

  scenario "Creating a new boost" do
    when_i_visit_the_adjustments_page
    and_i_click_the_new_boost_button
    and_i_fill_in_the_form_with_boost_adjustment_details
    then_the_boost_adjustment_should_be_created
    and_i_can_see_the_boost_adjustment_details
  end

  scenario "Creating a new filter" do
    when_i_visit_the_adjustments_page
    and_i_click_the_new_filter_button
    and_i_fill_in_the_form_with_filter_adjustment_details
    then_the_filter_adjustment_should_be_created
    and_i_can_see_the_filter_adjustment_details
  end

  def given_several_adjustments_exist
    given_a_boost_adjustment_exists
    given_a_filter_adjustment_exists
  end

  def given_a_boost_adjustment_exists
    @boost_adjustment = create(:boost_adjustment)
  end

  def given_a_filter_adjustment_exists
    @filter_adjustment = create(:filter_adjustment)
  end

  def when_i_visit_the_adjustments_page
    visit adjustments_path
  end

  def and_i_click_the_new_boost_button
    click_link "New boost"
  end

  def and_i_click_the_new_filter_button
    click_link "New filter"
  end

  def and_i_fill_in_the_form_with_boost_adjustment_details
    fill_in "Name", with: "Boost adjustment"
    fill_in "Filter expression", with: 'link: ANY("/example")'
    fill_in "Boost factor", with: 0.42

    click_button "Save adjustment"
  end

  def and_i_fill_in_the_form_with_filter_adjustment_details
    fill_in "Name", with: "Filter adjustment"
    fill_in "Filter expression", with: 'link: ANY("/example")'

    click_button "Save adjustment"
  end

  def then_i_should_see_all_the_adjustments
    expect(page).to have_link(@boost_adjustment.name)
    expect(page).to have_link(@filter_adjustment.name)
  end

  def and_i_can_click_through_to_see_more_details
    click_link @boost_adjustment.name

    expect(page).to have_selector("h1", text: @boost_adjustment.name)
    expect(page).to have_content(@boost_adjustment.filter_expression)
  end

  def then_the_boost_adjustment_should_be_created
    expect(page).to have_content("The adjustment was successfully created.")
    expect(Adjustment.first).to be_boost_kind
  end

  def then_the_filter_adjustment_should_be_created
    expect(page).to have_content("The adjustment was successfully created.")
    expect(Adjustment.first).to be_filter_kind
  end

  def and_i_can_see_the_boost_adjustment_details
    expect(page).to have_selector("h1", text: "Boost adjustment")
    expect(page).to have_content('Filter expression link: ANY("/example")')
    expect(page).to have_content("Boost factor 0.42")
  end

  def and_i_can_see_the_filter_adjustment_details
    expect(page).to have_selector("h1", text: "Filter adjustment")
    expect(page).to have_content('Filter expression link: ANY("/example")')
  end
end
