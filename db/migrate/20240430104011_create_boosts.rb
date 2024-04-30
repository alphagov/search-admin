class CreateBoosts < ActiveRecord::Migration[7.1]
  def change
    create_table :boosts do |t|
      t.string :filter, null: false
      t.float :boost_amount, null: false
      t.text :comment

      t.belongs_to :created_by, foreign_key: { to_table: :users }
      t.belongs_to :updated_by, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
