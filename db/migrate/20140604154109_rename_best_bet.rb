class RenameBestBet < ActiveRecord::Migration
  def change
    rename_table :best_bets, :bets
  end
end
