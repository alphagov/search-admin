RSpec.describe "Document exclusions" do
  scenario "Viewing document exclusions" do
    given_several_document_exclusions

    when_i_visit_the_document_exclusions_page

    then_all_document_exclusions_are_displayed
    and_i_can_click_through_to_see_more_details
  end

  scenario "Creating a new document exclusion" do
    when_i_visit_the_document_exclusions_page
    and_i_choose_to_add_a_new_document_exclusion
    and_i_submit_the_form_with_valid_details

    then_the_document_exclusion_has_been_created
    and_i_can_see_the_details_of_the_new_document_exclusion
  end

  scenario "Editing an existing document exclusion" do
    given_a_document_exclusion

    when_i_go_to_view_the_document_exclusion
    and_i_choose_to_edit_it
    and_i_submit_the_form_with_updated_details

    then_the_document_exclusion_has_been_updated_locally
    and_i_can_see_the_updated_details
  end

  scenario "Deleting an existing document exclusion" do
    given_a_document_exclusion

    when_i_go_to_view_the_document_exclusion
    and_i_choose_to_delete_it

    then_the_document_exclusion_has_been_deleted_locally
    and_i_am_notified_of_the_deletion
  end

  def given_several_document_exclusions
    @document_exclusions = create_list(:document_exclusion, 3)
  end

  def given_a_document_exclusion
    @document_exclusion = create(:document_exclusion)
  end

  def when_i_visit_the_document_exclusions_page
    visit document_exclusions_path
  end

  def and_i_choose_to_add_a_new_document_exclusion
    click_on "New"
  end

  def and_i_submit_the_form_with_valid_details
    fill_in "Link", with: "/government/example/new-link"
    fill_in "Comment", with: "New comment"
    click_on "Save"
  end

  def when_i_go_to_view_the_document_exclusion
    visit document_exclusion_path(@document_exclusion)
  end

  def and_i_choose_to_edit_it
    click_on "Edit"
  end

  def and_i_submit_the_form_with_updated_details
    fill_in "Link", with: "/government/example/updated-link"
    fill_in "Comment", with: "Updated comment"
    click_on "Save"
  end

  def and_i_choose_to_delete_it
    click_on "Delete"
  end

  def then_all_document_exclusions_are_displayed
    @document_exclusions.each do |document_exclusion|
      expect(page).to have_content(document_exclusion.link)
    end
  end

  def and_i_can_click_through_to_see_more_details
    click_on @document_exclusions.first.link
    expect(page).to have_content(@document_exclusions.first.link)
  end

  def then_the_document_exclusion_has_been_created
    document_exclusion = DocumentExclusion.last
    expect(document_exclusion.link).to eq("/government/example/new-link")
    expect(document_exclusion.comment).to eq("New comment")

    expect(page).to have_content("was successfully created")
  end

  def and_i_can_see_the_details_of_the_new_document_exclusion
    expect(page).to have_selector("h1", text: "/government/example/new-link")
    expect(page).to have_content("New comment")
  end

  def then_the_document_exclusion_has_been_updated_locally
    expect(@document_exclusion.reload.link).to eq("/government/example/updated-link")
    expect(@document_exclusion.reload.comment).to eq("Updated comment")

    expect(page).to have_content("was successfully updated")
  end

  def and_i_can_see_the_updated_details
    expect(page).to have_selector("h1", text: "/government/example/updated-link")
    expect(page).to have_content("Updated comment")
  end

  def then_the_document_exclusion_has_been_deleted_locally
    expect { @document_exclusion.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  def and_i_am_notified_of_the_deletion
    expect(page).to have_content("was successfully deleted")
  end
end
