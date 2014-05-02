class AddUserIdToBestBet < ActiveRecord::Migration
  def change
    remove_column :best_bets, :source
    add_column :best_bets, :user_id, :integer
    add_column :best_bets, :manual, :boolean, default: false
  end
end
