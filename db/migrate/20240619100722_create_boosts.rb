class CreateBoosts < ActiveRecord::Migration[7.1]
  def change
    create_table :boosts do |t|
      t.string :name, null: false
      t.boolean :active, null: false
      t.float :boost_amount, null: false
      t.text :filter, null: false

      t.timestamps
    end
  end
end
