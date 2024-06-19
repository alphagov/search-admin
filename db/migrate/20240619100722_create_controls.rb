class CreateControls < ActiveRecord::Migration[7.1]
  def change
    create_table :controls do |t|
      t.string :display_name

      t.timestamps
    end
  end
end
