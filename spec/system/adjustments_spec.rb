RSpec.describe "Adjustments", type: :system do
  scenario "Viewing adjustments" do
    given_several_adjustments_exist
    when_i_visit_the_adjustments_page
    then_i_should_see_all_the_adjustments
    and_i_can_click_through_to_see_more_details
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

  def then_i_should_see_all_the_adjustments
    expect(page).to have_link(@boost_adjustment.name)
    expect(page).to have_link(@filter_adjustment.name)
  end

  def and_i_can_click_through_to_see_more_details
    click_link @boost_adjustment.name

    expect(page).to have_selector("h1", text: @boost_adjustment.name)
    expect(page).to have_content(@boost_adjustment.filter_expression)
  end
end
