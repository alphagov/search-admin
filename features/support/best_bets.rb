def create_best_bet(query)
  visit new_best_bet_path
  fill_in 'Query', with: query
  click_on 'Save'
end

def check_for_best_bet_on_index_page(query)
  visit best_bets_path
  expect(page).to have_content(query)
end

def edit_best_bet(best_bet, query)
  visit edit_best_bet_path(best_bet)
  fill_in 'Query', with: query
  click_on 'Save'
end
