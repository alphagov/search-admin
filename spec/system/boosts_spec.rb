RSpec.describe "Boosts" do
  scenario "Viewing boosts" do
    given_several_boosts

    when_i_visit_the_boosts_page

    then_all_boosts_are_displayed
  end

  def given_several_boosts
    @boost1 = create(:boost, name: "Boost 1")
    @boost2 = create(:boost, name: "Boost 2")
  end

  def when_i_visit_the_boosts_page
    visit "/"
    click_on "Boosts"
  end

  def then_all_boosts_are_displayed
    expect(page).to have_link("Boost 1")
    expect(page).to have_link("Boost 2")
  end
end
