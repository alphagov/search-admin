Then(/^the recommended link should have been sent to the mainstream index$/) do
  check_rummager_was_sent_an_exact_recommended_link_document(
    recommended_link: RecommendedLink.last,
    index: "mainstream"
  )
end

Then(/^the edited recommended link should have been sent to the mainstream index$/) do
  check_rummager_was_sent_an_exact_recommended_link_document(
    recommended_link: RecommendedLink.last,
    index: "mainstream"
  )
end

Then(/^the recommended link "(.*)" should have been deleted in the mainstream index$/) do |link|
  check_rummager_was_sent_a_recommended_link_delete(
    link: link,
    index: "mainstream"
  )
end
