RSpec.describe "Completion denylist entries", type: :system do
  scenario "Viewing denylist entries" do
    given_several_completion_denylist_entries_exist

    when_i_visit_the_completion_denylist_entries_page
    then_i_should_see_the_general_completion_denylist_entry

    when_i_select_the_names_tab
    then_i_should_see_the_name_completion_denylist_entry
  end

  scenario "Editing an existing denylist entry" do
    given_an_offensive_completion_denylist_entry

    when_i_visit_the_completion_denylist_entries_page
    and_i_select_the_offensive_tab
    and_i_choose_to_edit_the_completion_denylist_entry
    and_i_submit_the_form_with_updated_details

    then_the_completion_denylist_entry_has_been_updated
    and_i_can_see_the_updated_details
  end

  scenario "Attempting to edit a denylist entry with invalid data" do
    given_an_offensive_completion_denylist_entry

    when_i_visit_the_completion_denylist_entries_page
    and_i_select_the_offensive_tab
    and_i_choose_to_edit_the_completion_denylist_entry
    and_i_submit_the_form_with_invalid_details

    then_the_completion_denylist_entry_has_not_been_updated
    and_i_can_see_what_errors_i_need_to_fix
  end

  scenario "Creating a new denylist entry" do
    when_i_visit_the_completion_denylist_entries_page
    and_i_choose_to_add_a_new_entry
    and_i_submit_the_form_with_valid_details

    then_i_should_see_the_new_completion_denylist_entry
  end

  scenario "Attempting to create a denylist entry with invalid data" do
    when_i_visit_the_completion_denylist_entries_page
    and_i_choose_to_add_a_new_entry
    and_i_submit_the_form_with_invalid_details

    then_the_completion_denylist_entry_has_not_been_created
    and_i_can_see_what_errors_i_need_to_fix
  end

  scenario "Deleting an existing denylist entry" do
    given_an_offensive_completion_denylist_entry

    when_i_visit_the_completion_denylist_entries_page
    and_i_select_the_offensive_tab
    and_i_choose_to_edit_the_completion_denylist_entry
    and_i_choose_to_delete_the_completion_denylist_entry

    then_the_completion_denylist_entry_has_been_deleted
  end

  def given_several_completion_denylist_entries_exist
    @completion_denylist_entry_general = create(
      :completion_denylist_entry,
      phrase: "foobar",
      match_type: :contains,
      category: :general,
    )
    @completion_denylist_entry_name = create(
      :completion_denylist_entry,
      phrase: "jim hacker",
      match_type: :exact_match,
      category: :names,
    )
  end

  def given_an_offensive_completion_denylist_entry
    @offensive_completion_denylist_entry = create(
      :completion_denylist_entry,
      phrase: "wagile",
      match_type: :contains,
      category: :offensive,
    )
  end

  def when_i_visit_the_completion_denylist_entries_page
    visit completion_denylist_entries_path
  end

  def when_i_select_the_names_tab
    click_on "Names"
  end

  def and_i_select_the_offensive_tab
    click_on "Offensive"
  end

  def and_i_choose_to_edit_the_completion_denylist_entry
    click_on @offensive_completion_denylist_entry.phrase
  end

  def and_i_submit_the_form_with_updated_details
    fill_in "Phrase", with: "scrum"
    fill_in "Comment", with: "No better than PRINCE2"
    choose "Exact match"

    click_on "Save denylist entry"
  end

  def and_i_choose_to_add_a_new_entry
    click_on "New denylist entry"
  end

  def and_i_submit_the_form_with_valid_details
    choose "Names"
    fill_in "Phrase", with: "foobar"
    fill_in "Comment", with: "This is a test entry"
    choose "Contains"

    click_on "Save denylist entry"
  end

  def and_i_submit_the_form_with_invalid_details
    fill_in "Phrase", with: ""

    click_on "Save denylist entry"
  end

  def and_i_can_see_what_errors_i_need_to_fix
    expect(page).to have_content("Phrase can't be blank")
  end

  def and_i_choose_to_delete_the_completion_denylist_entry
    click_on "Delete"
  end

  def then_i_should_see_the_general_completion_denylist_entry
    expect(page).to have_selector("td", text: "foobar")
  end

  def then_i_should_see_the_name_completion_denylist_entry
    expect(page).to have_selector("td", text: "jim⎵hacker")
  end

  def then_the_completion_denylist_entry_has_been_updated
    @offensive_completion_denylist_entry.reload

    expect(@offensive_completion_denylist_entry.phrase).to eq("scrum")
    expect(@offensive_completion_denylist_entry.comment).to eq("No better than PRINCE2")
    expect(@offensive_completion_denylist_entry.match_type).to eq("exact_match")
    expect(@offensive_completion_denylist_entry.category).to eq("offensive")
  end

  def then_the_completion_denylist_entry_has_not_been_updated
    @offensive_completion_denylist_entry.reload

    expect(@offensive_completion_denylist_entry.phrase).to eq("wagile")
  end

  def then_the_completion_denylist_entry_has_not_been_created
    expect(CompletionDenylistEntry.count).to be_zero
  end

  def and_i_can_see_the_updated_details
    expect(page).to have_selector("td", text: "scrumNo better than PRINCE2")
    expect(page).to have_selector("td", text: "Exact match")
  end

  def then_i_should_see_the_new_completion_denylist_entry
    expect(page).to have_selector("td", text: "foobarThis is a test entry")
    expect(page).to have_selector("td", text: "Contains")
  end

  def then_the_completion_denylist_entry_has_been_deleted
    expect(CompletionDenylistEntry.exists?(@offensive_completion_denylist_entry.id)).to eq(false)
    expect(page).not_to have_selector("td", text: "wagile")
    expect(page).to have_content("The denylist entry was successfully deleted.")
  end
end
