Then(/^the merged best bets should have been sent to the metasearch index$/) do
  check_rummager_was_sent_an_exact_best_bet_document(BestBet.all)
end

Then(/^the remaining merged best bets should have been sent to the metasearch index$/) do
  check_rummager_was_sent_an_exact_best_bet_document(BestBet.all)
end
