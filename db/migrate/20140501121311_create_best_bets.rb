class CreateBestBets < ActiveRecord::Migration
  def change
    create_table :best_bets do |t|
      t.string :query
      t.string :match_type
      t.string :link
      t.integer :position
      t.string :comment
      t.string :source
    end
  end
end
