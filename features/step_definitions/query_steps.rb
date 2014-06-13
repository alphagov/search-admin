When(/^I create a new query$/) do
  create_query(query: 'jobs', match_type: 'exact')
end

Then(/^the query should be listed on the query index$/) do
  check_for_query_on_index_page(query: 'jobs', match_type: 'exact')
end

When(/^I edit the query$/) do
  edit_query(query_text: @query.query, match_type: @query.match_type, new_query_text: 'visas')
end

Then(/^the edited query should be listed on the query index$/) do
  check_for_query_on_index_page(query: 'visas', match_type: @query.match_type)
end

When(/^I delete the query$/) do
  delete_query(query_text: @query.query, match_type: @query.match_type)
end

Then(/^the query should not be listed on the query index$/) do
  check_for_absence_of_query_on_index_page(query: @query.query, match_type: @query.match_type)
end
