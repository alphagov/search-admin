class CreateAdjustments < ActiveRecord::Migration[8.0]
  def change
    create_table :adjustments do |t|
      t.integer :kind, null: false
      t.string :name, null: false
      t.string :filter_expression, null: false
      t.float :boost_factor

      t.timestamps
    end
  end
end
