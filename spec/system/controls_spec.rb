RSpec.describe "Controls" do
  scenario "Viewing controls" do
    given_several_controls

    when_i_visit_the_controls_page

    then_all_controls_are_displayed
  end

  def given_several_controls
    @control1 = create(:control, name: "Control 1")
    @control2 = create(:control, name: "Control 2")
  end

  def when_i_visit_the_controls_page
    visit "/"
    click_on "Controls"
  end

  def then_all_controls_are_displayed
    expect(page).to have_link("Control 1")
    expect(page).to have_link("Control 2")
  end
end
