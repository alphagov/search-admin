class CreateDocumentExclusions < ActiveRecord::Migration[8.0]
  def change
    create_table :document_exclusions do |t|
      t.string :link, null: false
      t.text :comment, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps

      t.index :link, unique: true
    end
  end
end
