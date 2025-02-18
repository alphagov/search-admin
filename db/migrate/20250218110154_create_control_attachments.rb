class CreateControlAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :control_attachments do |t|
      t.references :control, null: false, foreign_key: true
      t.references :serving_config, null: false, foreign_key: true

      t.timestamps
    end

    add_column :controls, :control_attachments_count, :integer, null: false, default: 0
    add_column :serving_configs, :control_attachments_count, :integer, null: false, default: 0
  end
end
