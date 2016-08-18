Given(/^a recommended link exists named "(.*)" with link "(.*)"$/) do |title, link|
  @recommended_link = create(:recommended_link, title: title, link: link)
end

Given(/^there are some recommended links$/) do
  @recommended_links = (1..3).map { |n|
    create(:recommended_link, title: "Tax online #{n}", link: "https://www.tax.service.gov.uk/#{n}")
  }
end

Given(/^a variety of recommended links exist$/) do
  create(:recommended_link, title: "Jobs", link: "https://www.gov.uk/jobsearch")
  create(:recommended_link, title: "Visas", link: "https://www.gov.uk/apply-uk-visa")
  create(:recommended_link, title: "Blogs", link: "https://www.blog.gov.uk/")
end

When(/^I create a new recommended link$/) do
  create_recommended_link(
    title: 'Tax online',
    link: 'https://www.tax.service.gov.uk/',
    description: 'File your self assessment online.',
    keywords: 'tax, self assessment, hmrc',
    search_index: 'mainstream'
  )
end

Then(/^the recommended link named "(.*)" should be listed on the recommended links index$/) do |title|
  check_for_recommended_link_on_index_page(title: title)
end

When(/^I edit the recommended link named "(.*)" with link "(.*)" to be named "(.*)"$/) do |old_title, link, new_title|
  edit_recommended_link(
    old_title: old_title,
    old_link: link,
    title: new_title
  )
end

Then(/^the edited recommended link named "(.*)" should be listed on the recommended links index$/) do |title|
  check_for_recommended_link_on_index_page(title: title)
end

When(/^I delete the recommended link named "(.*)" with link "(.*)"$/) do |title, link|
  delete_recommended_link(title: title, link: link)
end

Then(/^the recommended link named "(.*)" should not be listed on the recommended links index$/) do |title|
  check_for_absence_of_recommended_link_on_index_page(title: title)
end

When(/^I visit the recommended link$/) do
  visit recommended_link_path(@recommended_link || RecommendedLink.last)
end

Then(/^I should see the recommended links search results on the page$/) do
  expect(page).to have_selector('iframe')
  expect(find('iframe')[:src]).to include 'gov.uk/search?q=Tax+online'
end
