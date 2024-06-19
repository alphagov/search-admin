class CreateControls < ActiveRecord::Migration[7.1]
  def change
    create_table :controls do |t|
      t.string :name
      t.float :boost_amount
      t.text :filter
      t.boolean :active

      t.timestamps
    end
  end
end
