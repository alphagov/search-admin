RSpec.describe "Recommended links" do
  before do
    # TODO: Refactor me out into a support file (once we have more system specs and old
    # controller specs are gone)
    GDS::SSO.test_user = create(:user)

    allow(ExternalContentPublisher).to receive(:publish)
    allow(ExternalContentPublisher).to receive(:unpublish)
  end

  let!(:link_1) do
    create(
      :recommended_link,
      content_id: "00000000-0000-0000-0000-000000000001",
      title: "Example link 1",
      link: "https://example.com",
      description: "Example description 1",
    )
  end
  let!(:link_2) do
    create(
      :recommended_link,
      content_id: "00000000-0000-0000-0000-000000000002",
      title: "Example link 2",
      link: "https://example.org",
      description: "Example description 2",
    )
  end

  scenario "Viewing all external links" do
    visit "/recommended-links"

    expect(page).to have_link("Example link 1")
    expect(page).to have_link("Example link 2")
  end

  scenario "Viewing a single external link" do
    visit "/recommended-links"
    click_on "Example link 1"

    expect(page).to have_selector("h1", text: "Example link 1")
  end

  scenario "Editing an existing external link" do
    visit "/recommended-links"

    click_on "Example link 1"

    click_on "Edit"

    fill_in "Title", with: "Updated title"
    fill_in "Link", with: "https://example.com/updated"
    fill_in "Description", with: "Updated description"
    fill_in "Keywords", with: "Updated keywords"
    fill_in "Comment", with: "Updated comments"
    click_on "Save"

    expect(ExternalContentPublisher).to have_received(:publish).with(link_1)
    expect(page).to have_selector("h1", text: "Updated title")

    link_1.reload
    expect(link_1.title).to eq("Updated title")
    expect(link_1.link).to eq("https://example.com/updated")
    expect(link_1.description).to eq("Updated description")
    expect(link_1.keywords).to eq("Updated keywords")
    expect(link_1.comment).to eq("Updated comments")
  end

  scenario "Deleting an existing external link" do
    visit "/recommended-links"
    click_on "Example link 1"
    click_on "Delete"

    expect(ExternalContentPublisher).to have_received(:unpublish).with(link_1)
    expect(page).to have_content("Your external link was deleted successfully")

    expect(RecommendedLink.find_by(content_id: "00000000-0000-0000-0000-000000000001")).to be_nil
  end

  scenario "Creating a new external link"
  scenario "Downloading a list of external links in CSV format"
end
