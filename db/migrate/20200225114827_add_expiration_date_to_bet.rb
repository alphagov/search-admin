class AddExpirationDateToBet < ActiveRecord::Migration[6.0]
  def change
    add_column :bets, :expiration_date, :datetime
  end
end
