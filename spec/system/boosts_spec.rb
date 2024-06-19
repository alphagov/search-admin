RSpec.describe "Boosts" do
  scenario "Viewing boosts" do
    given_several_boosts

    when_i_visit_the_boosts_page

    then_all_boosts_are_displayed
  end

  scenario "Viewing a single boost" do
    given_a_boost

    when_i_go_to_view_the_boost

    then_i_can_see_the_details_of_the_boost
  end

  def given_several_boosts
    @boost1 = create(:boost, name: "Boost 1")
    @boost2 = create(:boost, name: "Boost 2")
  end

  def given_a_boost
    @boost = create(
      :boost,
      name: "Boost",
      active: true,
      boost_amount: 0.42,
      filter: 'foo: ANY("bar")',
    )
  end

  def when_i_visit_the_boosts_page
    visit "/"
    click_on "Boosts"
  end

  def when_i_go_to_view_the_boost
    visit boosts_path
    click_on "Boost"
  end

  def then_all_boosts_are_displayed
    expect(page).to have_link("Boost 1")
    expect(page).to have_link("Boost 2")
  end

  def then_i_can_see_the_details_of_the_boost
    expect(page).to have_selector("h1", text: "Boost")
    expect(page).to have_content("Status Active")
    expect(page).to have_content("Boost amount 0.42")
    expect(page).to have_content('Filter expression foo: ANY("bar")')
  end
end
