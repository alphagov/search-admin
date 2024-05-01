class CreateDocumentControls < ActiveRecord::Migration[7.1]
  def change
    create_table :document_controls do |t|
      t.string :link, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
