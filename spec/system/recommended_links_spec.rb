RSpec.describe "Recommended links" do
  before do
    stub_external_content_publisher
  end

  scenario "Viewing recommended links" do
    given_several_recommended_links

    when_i_visit_the_recommended_links_page

    then_all_recommended_links_are_displayed
    and_i_can_click_through_to_see_more_details
  end

  scenario "Viewing a single recommended link" do
    given_a_recommended_link

    when_i_go_to_view_the_recommended_link

    then_i_can_see_a_preview_of_the_link
    and_i_can_choose_to_view_it_on_govuk_search
  end

  scenario "Editing an existing recommended link" do
    given_a_recommended_link

    when_i_go_to_view_the_recommended_link
    and_i_choose_to_edit_it
    and_i_submit_the_form_with_updated_details

    then_the_link_has_been_updated_locally
    and_the_changes_have_been_published
    and_i_can_see_the_new_title
  end

  scenario "Attempting to edit a recommended link with invalid data" do
    given_a_recommended_link

    when_i_go_to_view_the_recommended_link
    and_i_choose_to_edit_it
    and_i_submit_the_form_with_invalid_details

    then_the_link_has_not_been_updated
    and_it_has_not_been_published
    and_i_can_see_what_errors_i_need_to_fix
  end

  scenario "Deleting an existing recommended link" do
    given_a_recommended_link

    when_i_go_to_view_the_recommended_link
    and_i_choose_to_delete_it

    then_the_link_has_been_deleted_locally
    and_it_has_been_unpublished
    and_i_am_notified_of_the_deletion
  end

  scenario "Creating a new recommended link" do
    when_i_visit_the_recommended_links_page
    and_i_choose_to_add_a_new_link
    and_i_submit_the_form_with_valid_details

    then_the_new_link_has_been_created
    and_it_has_been_published
    and_i_can_see_its_details
  end

  scenario "Attempting to create a recommended link with invalid data" do
    when_i_visit_the_recommended_links_page
    and_i_choose_to_add_a_new_link
    and_i_submit_the_form_with_invalid_details

    then_the_link_has_not_been_created
    and_it_has_not_been_published
    and_i_can_see_what_errors_i_need_to_fix
  end

  scenario "Downloading a list of recommended links in CSV format" do
    given_several_recommended_links

    when_i_visit_the_recommended_links_page
    and_i_choose_to_download_a_csv_of_links

    then_a_csv_file_is_downloaded
    and_it_contains_all_links
  end

  def stub_external_content_publisher
    allow(ExternalContentPublisher).to receive(:publish)
    allow(ExternalContentPublisher).to receive(:unpublish)
  end

  def given_a_recommended_link
    @link = create(
      :recommended_link,
      content_id: "00000000-0000-0000-0000-000000000001",
      title: "Example link",
      link: "https://example.com",
      description: "Example description",
    )
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

  def when_i_go_to_view_the_recommended_link
    visit recommended_links_path
    click_on "Example link"
  end

  def and_i_choose_to_edit_it
    click_on "Edit"
  end

  def and_i_submit_the_form_with_updated_details
    fill_in "Title", with: "Updated title"
    fill_in "Link", with: "https://example.com/updated"
    fill_in "Description", with: "Updated description"
    fill_in "Keywords", with: "Updated keywords"
    fill_in "Comment", with: "Updated comments"
    click_on "Save"
  end

  def and_i_submit_the_form_with_invalid_details
    fill_in "Title", with: ""
    fill_in "Link", with: "NOTALINK"
    fill_in "Description", with: ""
    click_on "Save"
  end

  def and_i_choose_to_delete_it
    click_on "Delete"
  end

  def and_i_choose_to_add_a_new_link
    click_on "New external link"
  end

  def and_i_submit_the_form_with_valid_details
    fill_in "Title", with: "A title"
    fill_in "Link", with: "https://example.net"
    fill_in "Description", with: "A description"
    fill_in "Keywords", with: "A keyword"
    fill_in "Comment", with: "A comment"
    click_on "Save"
  end

  def then_all_recommended_links_are_displayed
    expect(page).to have_link("Example link 1")
    expect(page).to have_link("Example link 2")
  end

  def and_i_can_click_through_to_see_more_details
    click_on "Example link 1"
    expect(page).to have_selector("h1", text: "Example link 1")
  end

  def then_i_can_see_a_preview_of_the_link
    within("#recommended_link_preview") do
      expect(page).to have_link("Example link", href: "https://example.com")
      expect(page).to have_content("Example description")
    end
  end

  def and_i_can_choose_to_view_it_on_govuk_search
    expect(page).to have_link(
      "View on GOV.UK Search",
      href: %r{^https://www\.test\.gov\.uk/search/all\?.+keywords=Example\+link},
    )
  end

  def then_the_link_has_been_updated_locally
    @link.reload
    expect(@link.title).to eq("Updated title")
    expect(@link.link).to eq("https://example.com/updated")
    expect(@link.description).to eq("Updated description")
    expect(@link.keywords).to eq("Updated keywords")
    expect(@link.comment).to eq("Updated comments")
  end

  def and_the_changes_have_been_published
    expect(ExternalContentPublisher).to have_received(:publish).with(@link)
  end

  def and_i_can_see_the_new_title
    expect(page).to have_selector("h1", text: "Updated title")
  end

  def then_the_link_has_not_been_updated
    @link.reload
    expect(@link.title).to eq("Example link")
    expect(@link.link).to eq("https://example.com")
    expect(@link.description).to eq("Example description")
  end

  def and_it_has_not_been_published
    expect(ExternalContentPublisher).not_to have_received(:publish)
  end

  def and_i_can_see_what_errors_i_need_to_fix
    expect(page).to have_content("There is a problem")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Link is an invalid URL")
    expect(page).to have_content("Description can't be blank")
  end

  def then_the_link_has_been_deleted_locally
    expect(page).to have_content("The external link was successfully deleted")
  end

  def and_it_has_been_unpublished
    expect(ExternalContentPublisher).to have_received(:unpublish).with(@link)
  end

  def and_i_am_notified_of_the_deletion
    expect(RecommendedLink.find_by(content_id: "00000000-0000-0000-0000-000000000001")).to be_nil
  end

  def and_i_choose_to_download_a_csv_of_links
    click_on "Download CSV"
  end

  def then_the_new_link_has_been_created
    expect(RecommendedLink.last).to have_attributes(
      title: "A title",
      link: "https://example.net",
      description: "A description",
      keywords: "A keyword",
      comment: "A comment",
      content_id: a_string_matching(/\A[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}\z/),
    )
  end

  def and_it_has_been_published
    expect(ExternalContentPublisher).to have_received(:publish).with(RecommendedLink.last)
  end

  def and_i_can_see_its_details
    expect(page).to have_selector("h1", text: "A title")
  end

  def then_the_link_has_not_been_created
    expect(RecommendedLink.last).to be_nil
  end

  def then_a_csv_file_is_downloaded
    expect(page.response_headers["Content-Type"]).to eq("application/octet-stream")
    expect(page.response_headers["Content-Disposition"]).to eq("attachment")
  end

  def and_it_contains_all_links
    expect(page).to have_content("Example link 1,https://example.com,Example description 1")
    expect(page).to have_content("Example link 2,https://example.org,Example description 2")
  end
end
