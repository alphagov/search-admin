class AddQueryIdToBets < ActiveRecord::Migration
  def change
    add_column :bets, :query_id, :integer
    add_column :bets, :is_best, :boolean, default: true
    remove_column :bets, :query
    remove_column :bets, :match_type
  end
end
