class AddBoostAmountToControl < ActiveRecord::Migration[7.1]
  def change
    add_column :controls, :boost_amount, :float
  end
end
