RSpec.describe "Promoted content" do
  scenario "Viewing promoted content" do
    when_i_visit_the_promoted_content_page
    # ...
  end

  def when_i_visit_the_promoted_content_page
    visit "/"
    click_on "Promoted content"
  end
end
