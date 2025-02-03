class CreateServingConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :serving_configs do |t|
      t.string :discovery_engine_id,
               null: false,
               comment: "The ID of the remote resource on Discovery Engine"
      t.string :display_name,
               null: false,
               comment: "A human-readable name for this serving config"
      t.boolean :can_have_attached_controls,
                null: false,
                default: true,
                comment: "Whether or not users can attach controls to this serving config"
      t.text :comment,
             null: false,
             comment: "A descriptive comment explaining what this serving config is for"

      t.timestamps

      t.index :discovery_engine_id, unique: true
    end
  end
end
