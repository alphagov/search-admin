class AddUpdatedAtToBet < ActiveRecord::Migration[6.0]
  def change
    add_column :bets, :updated_at, :datetime
  end
end
