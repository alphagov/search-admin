class AddPermanentToBet < ActiveRecord::Migration[6.0]
  def change
    add_column :bets, :permanent, :bool, default: false
    Bet.reset_column_information
    Bet.all.each do |b|
      b.update_attribute :permanent, true
    end
  end
end
