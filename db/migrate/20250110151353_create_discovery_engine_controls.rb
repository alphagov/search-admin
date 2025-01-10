class CreateDiscoveryEngineControls < ActiveRecord::Migration[8.0]
  def change
    create_table :discovery_engine_controls do |t|
      t.string :name, null: false
      t.boolean :active, null: false
      t.integer :action, null: false
      t.string :filter, null: false
      t.float :boost_amount

      t.timestamps
    end
  end
end
