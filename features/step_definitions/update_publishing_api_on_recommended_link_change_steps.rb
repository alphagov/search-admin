Then(/^the external link should have been published$/) do
  check_recommended_link_was_published(RecommendedLink.last, 1)
end

Then(/^the external link should have been republished$/) do
  check_recommended_link_was_published(RecommendedLink.last, 2)
end

Then(/^the external link should have been unpublished$/) do
  check_recommended_link_was_unpublished(@recommended_link_content_id)
end
