class AddReferenceForUserIdToBestBets < ActiveRecord::Migration
  def up
    rename_column :bets, :user_id, :old_user_id
    add_reference :bets, :user

    Bet.all.each do |bet|
      bet.user_id = bet.old_user_id
      bet.save!
    end

    remove_column :bets, :old_user_id
  end

  def down
    rename_column :bets, :user_id, :old_user_id
    add_column :bets, :user_id, :integer

    Bet.all.each do |bet|
      bet.user_id = bet.old_user_id
      bet.save!
    end

    remove_column :bets, :old_user_id
  end
end
