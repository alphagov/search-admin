RSpec.describe "Promoted content" do
  scenario "Viewing promoted content" do
    given_some_boosts

    when_i_visit_the_promoted_content_page

    then_i_should_see_the_boosts
  end

  def given_some_boosts
    @boosts = FactoryBot.create_list(:boost, 3)
  end

  def when_i_visit_the_promoted_content_page
    visit "/"
    click_on "Promoted content"
  end

  def then_i_should_see_the_boosts
    @boosts.each do |boost|
      expect(page).to have_content(boost.filter)
      expect(page).to have_content(boost.boost_amount)
    end
  end
end
