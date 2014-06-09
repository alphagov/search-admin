Then(/^the query should have been sent to the metasearch index$/) do
  check_rummager_was_sent_an_exact_best_bet_document(Query.last)
end

Then(/^the remaining merged best bets should have been sent to the metasearch index$/) do
  check_rummager_was_sent_an_exact_best_bet_document(Query.last)
end

Then(/^the best bets should have been deleted in the metasearch index$/) do
  check_rummager_was_sent_a_best_bet_delete(@query_es_ids)
end
