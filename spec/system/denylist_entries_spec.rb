RSpec.describe "Denylist entries", type: :system do
  scenario "Viewing denylist entries" do
    given_several_denylist_entries_exist

    when_i_visit_the_denylist_entries_page
    then_i_should_see_the_general_denylist_entry

    when_i_select_the_names_tab
    then_i_should_see_the_name_denylist_entry
  end

  scenario "Editing an existing denylist entry" do
    given_an_offensive_denylist_entry

    when_i_visit_the_denylist_entries_page
    and_i_select_the_offensive_tab
    and_i_choose_to_edit_the_denylist_entry
    and_i_submit_the_form_with_updated_details

    then_the_denylist_entry_has_been_updated
    and_i_can_see_the_updated_details
  end

  def given_several_denylist_entries_exist
    @denylist_entry_general = create(
      :denylist_entry,
      phrase: "foobar",
      match_type: :contains,
      category: :general,
    )
    @denylist_entry_name = create(
      :denylist_entry,
      phrase: "jim hacker",
      match_type: :exact_match,
      category: :names,
    )
  end

  def given_an_offensive_denylist_entry
    @offensive_denylist_entry = create(
      :denylist_entry,
      phrase: "wagile",
      match_type: :contains,
      category: :offensive,
    )
  end

  def when_i_visit_the_denylist_entries_page
    visit denylist_entries_path
  end

  def when_i_select_the_names_tab
    click_on "Names"
  end

  def and_i_select_the_offensive_tab
    click_on "Offensive"
  end

  def and_i_choose_to_edit_the_denylist_entry
    click_on "Edit"
  end

  def and_i_submit_the_form_with_updated_details
    fill_in "Phrase", with: "scrum"
    fill_in "Comment", with: "No better than PRINCE2"
    choose "Exact match"

    click_on "Save denylist entry"
  end

  def then_i_should_see_the_general_denylist_entry
    expect(page).to have_selector("td", text: "foobar")
  end

  def then_i_should_see_the_name_denylist_entry
    expect(page).to have_selector("td", text: "jim⎵hacker")
  end

  def then_the_denylist_entry_has_been_updated
    @offensive_denylist_entry.reload

    expect(@offensive_denylist_entry.phrase).to eq("scrum")
    expect(@offensive_denylist_entry.comment).to eq("No better than PRINCE2")
    expect(@offensive_denylist_entry.match_type).to eq("exact_match")
    expect(@offensive_denylist_entry.category).to eq("offensive")
  end

  def and_i_can_see_the_updated_details
    expect(page).to have_selector("td", text: "scrumNo better than PRINCE2")
    expect(page).to have_selector("td", text: "Exact match")
  end
end
