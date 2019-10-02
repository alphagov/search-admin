Given(/^an external link exists named "(.*)" with link "(.*)"$/) do |title, link|
  @recommended_link = create(:recommended_link, title: title, link: link)
end

Given(/^there are some external links$/) do
  @recommended_links = (1..3).map { |n|
    create(:recommended_link, title: "Tax online #{n}", link: "https://www.tax.service.gov.uk/#{n}")
  }
end

Given(/^a variety of external links exist$/) do
  create(:recommended_link, title: "Jobs", link: "https://www.gov.uk/jobsearch")
  create(:recommended_link, title: "Visas", link: "https://www.gov.uk/apply-uk-visa")
  create(:recommended_link, title: "Blogs", link: "https://www.blog.gov.uk/")
end

When(/^I create a new external link$/) do
  create_recommended_link(
    title: "Tax online",
    link: "https://www.tax.service.gov.uk/",
    description: "File your self assessment online.",
    keywords: "tax, self assessment, hmrc",
  )

  @recommended_link_content_id = RecommendedLink.last.content_id
end

Then(/^the external link named "(.*)" should be listed on the external links index$/) do |title|
  check_for_recommended_link_on_index_page(title: title)
end

When(/^I edit the external link named "(.*)" with link "(.*)" to be named "(.*)"$/) do |old_title, link, new_title|
  edit_recommended_link(
    old_title: old_title,
    old_link: link,
    title: new_title,
  )
end

Then(/^the edited external link named "(.*)" should be listed on the external links index$/) do |title|
  check_for_recommended_link_on_index_page(title: title)
end

When(/^I delete the external link named "(.*)" with link "(.*)"$/) do |title, link|
  delete_recommended_link(title: title, link: link)
end

Then(/^the external link named "(.*)" should not be listed on the external links index$/) do |title|
  check_for_absence_of_recommended_link_on_index_page(title: title)
end

When(/^I visit the external link$/) do
  visit recommended_link_path(@recommended_link || RecommendedLink.last)
end

Then(/^I should see the external links search results on the page$/) do
  expect(page).to have_selector("iframe")
  expect(find("iframe")[:src]).to include "gov.uk/search?q=Tax+online"
end
