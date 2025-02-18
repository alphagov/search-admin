class CreateControlAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :control_attachments do |t|
      t.references :control, null: false, foreign_key: true
      t.references :serving_config, null: false, foreign_key: true

      t.timestamps
    end

    add_index :control_attachments, %i[control_id serving_config_id], unique: true
  end
end
