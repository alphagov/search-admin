class CreateControls < ActiveRecord::Migration[8.0]
  def change
    create_table :controls do |t|
      t.string :action_type, null: false
      t.integer :action_id, null: false
      t.string :display_name, null: false

      t.timestamps

      t.index %i[action_type action_id], unique: true
    end

    create_table :control_boost_actions do |t|
      t.string :filter_expression, null: false
      t.float :boost_factor, null: false

      t.timestamps

      t.check_constraint "boost_factor BETWEEN -1.0 AND 1.0 AND boost_factor != 0",
                         name: :valid_boost_factor
    end

    create_table :control_filter_actions do |t|
      t.string :filter_expression, null: false

      t.timestamps
    end
  end
end
