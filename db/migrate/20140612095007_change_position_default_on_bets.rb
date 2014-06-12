class ChangePositionDefaultOnBets < ActiveRecord::Migration
  def up
    change_column_default :bets, :position, 1
  end

  def down
    change_column_default :bets, :position, nil
  end
end
