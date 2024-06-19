RSpec.describe "Controls" do
  scenario "Viewing controls" do
    given_several_controls

    when_i_visit_the_controls_page

    then_all_controls_are_displayed
  end

  scenario "Viewing a single control" do
    given_a_control

    when_i_go_to_view_the_control

    then_i_can_see_the_details_of_the_control
  end

  def given_several_controls
    @control1 = create(:control, name: "Control 1")
    @control2 = create(:control, name: "Control 2")
  end

  def given_a_control
    @control = create(
      :control,
      name: "Control",
      active: true,
      boost_amount: 0.42,
      filter: 'foo: ANY("bar")',
    )
  end

  def when_i_visit_the_controls_page
    visit "/"
    click_on "Controls"
  end

  def when_i_go_to_view_the_control
    visit controls_path
    click_on "Control"
  end

  def then_all_controls_are_displayed
    expect(page).to have_link("Control 1")
    expect(page).to have_link("Control 2")
  end

  def then_i_can_see_the_details_of_the_control
    expect(page).to have_selector("h1", text: "Control")
  end
end
