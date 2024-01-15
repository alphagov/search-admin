class AddCreatedAtToBet < ActiveRecord::Migration[6.0]
  def change
    add_column :bets, :created_at, :datetime
    Bet.reset_column_information
    Bet.all.find_each do |b|
      b.update!(created_at: b.set_created_at)
    end
  end
end
