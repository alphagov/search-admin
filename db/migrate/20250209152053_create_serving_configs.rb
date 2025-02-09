class CreateServingConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :serving_configs do |t|
      t.string :display_name,
               null: false,
               comment: "A human-readable name"
      t.string :description,
               null: false,
               comment: "A description of this serving config's purpose"
      t.string :remote_resource_id,
               null: false,
               comment: "The ID of this serving config on Discovery Engine"
      t.boolean :users_can_assign_controls,
                null: false,
                comment: "Whether or not users can assign controls to this serving config in the UI"

      t.timestamps

      t.index :remote_resource_id, unique: true
    end
  end
end
