class RemoveControlsAndServingConfigs < ActiveRecord::Migration[8.0]
  def up
    drop_table :control_attachments
    drop_table :control_boost_actions
    drop_table :control_filter_actions
    drop_table :controls
    drop_table :serving_configs
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
