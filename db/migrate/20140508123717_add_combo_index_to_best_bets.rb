class AddComboIndexToBestBets < ActiveRecord::Migration
  def change
    add_index "best_bets", ["query", "match_type"], :name => "query_match_type_index"
  end
end
