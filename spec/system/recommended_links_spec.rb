RSpec.describe "Recommended links" do
  before do
    # TODO: Refactor me out into a support file (once we have more system specs and old
    # controller specs are gone that this might conflict with)
    GDS::SSO.test_user = create(:user)
  end

  scenario "Viewing recommended links" do
    given_several_recommended_links

    when_i_visit_the_recommended_links_page

    then_all_recommended_links_are_displayed
    and_i_can_click_through_to_see_more_details
  end

  def given_several_recommended_links
    @link_1 = create(
      :recommended_link,
      content_id: "00000000-0000-0000-0000-000000000001",
      title: "Example link 1",
      link: "https://example.com",
      description: "Example description 1",
    )

    @link_2 = create(
      :recommended_link,
      content_id: "00000000-0000-0000-0000-000000000002",
      title: "Example link 2",
      link: "https://example.org",
      description: "Example description 2",
    )
  end

  def when_i_visit_the_recommended_links_page
    visit "/"
    click_on "External links"
  end

  def then_all_recommended_links_are_displayed
    expect(page).to have_link("Example link 1")
    expect(page).to have_link("Example link 2")
  end

  def and_i_can_click_through_to_see_more_details
    click_on "Example link 1"
    expect(page).to have_selector("h1", text: "Example link 1")
  end
end
