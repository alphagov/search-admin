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

  scenario "Creating a new boost" do
    when_i_visit_the_boosts_page
    and_i_choose_to_create_a_new_boost
    and_i_submit_the_form_with_valid_details

    then_the_boost_has_been_created
    and_i_can_see_its_details
  end

  scenario "Attempting to create a boost with invalid data" do
    when_i_visit_the_boosts_page
    and_i_choose_to_create_a_new_boost
    and_i_submit_the_form_with_invalid_details

    then_the_boost_has_not_been_created
    and_i_can_see_what_errors_i_need_to_fix
  end

  scenario "Editing an existing boost" do
    given_a_boost

    when_i_go_to_view_the_boost
    and_i_choose_to_edit_it
    and_i_submit_the_form_with_updated_details

    then_the_boost_has_been_updated
    and_i_can_see_the_new_details
  end

  scenario "Attempting to edit a boost with invalid data" do
    given_a_boost

    when_i_go_to_view_the_boost
    and_i_choose_to_edit_it
    and_i_submit_the_form_with_invalid_details

    then_the_boost_has_not_been_updated
    and_i_can_see_what_errors_i_need_to_fix
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

  def and_i_choose_to_create_a_new_boost
    click_on "New boost"
  end

  def and_i_submit_the_form_with_valid_details
    fill_in "Name", with: "New boost"
    fill_in "Boost amount", with: 0.42
    fill_in "Filter", with: 'foo: ANY("bar")'
    check "Activate boost"
    click_on "Save"
  end

  def and_i_submit_the_form_with_invalid_details
    fill_in "Name", with: ""
    fill_in "Boost amount", with: 42.0
    fill_in "Filter", with: ""
    check "Activate boost"
    click_on "Save"
  end

  def and_i_choose_to_edit_it
    click_on "Edit"
  end

  def and_i_submit_the_form_with_updated_details
    fill_in "Name", with: "Updated boost"
    fill_in "Boost amount", with: 0.84
    fill_in "Filter", with: 'foo: ANY("bubble")'
    uncheck "Activate boost"
    click_on "Save"
  end

  def then_the_boost_has_not_been_created
    expect(Boost.count).to eq(0)
  end

  def and_i_can_see_what_errors_i_need_to_fix
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Filter expression can't be blank")
    expect(page).to have_content("Boost amount must be less than or equal to 1.0")
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

  def then_the_boost_has_been_created
    expect(Boost.count).to eq(1)

    boost = Boost.first
    expect(boost.name).to eq("New boost")
    expect(boost).to be_active
    expect(boost.boost_amount).to eq(0.42)
    expect(boost.filter).to eq('foo: ANY("bar")')
  end

  def and_i_can_see_its_details
    expect(page).to have_selector("h1", text: "New boost")
    expect(page).to have_content("Status Active")
    expect(page).to have_content("Boost amount 0.42")
    expect(page).to have_content('Filter expression foo: ANY("bar")')
  end

  def then_the_boost_has_been_updated
    @boost.reload

    expect(@boost.name).to eq("Updated boost")
    expect(@boost).not_to be_active
    expect(@boost.boost_amount).to eq(0.84)
    expect(@boost.filter).to eq('foo: ANY("bubble")')
  end

  def and_i_can_see_the_new_details
    expect(page).to have_selector("h1", text: "Updated boost")
    expect(page).to have_content("Status Not active")
    expect(page).to have_content("Boost amount 0.84")
    expect(page).to have_content('Filter expression foo: ANY("bubble")')
  end

  def then_the_boost_has_not_been_updated
    @boost.reload

    expect(@boost.name).to eq("Boost")
    expect(@boost).to be_active
    expect(@boost.boost_amount).to eq(0.42)
    expect(@boost.filter).to eq('foo: ANY("bar")')
  end
end
