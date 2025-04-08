class CreateDenylistEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :denylist_entries do |t|
      t.string :phrase, null: false
      t.integer :match_type, null: false, default: 0
      t.integer :category, null: false, default: 0
      t.string :comment

      t.index :category
      t.index :phrase, unique: true

      t.timestamps
    end
  end
end
