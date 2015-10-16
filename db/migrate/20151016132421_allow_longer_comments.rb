class AllowLongerComments < ActiveRecord::Migration
  def change
    change_column :bets, :comment, :text
  end
end
