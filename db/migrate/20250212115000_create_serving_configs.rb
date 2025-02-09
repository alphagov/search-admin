class CreateServingConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :serving_configs do |t|
      t.integer :use_case,
                null: false,
                comment: "An enum declaring what use case this serving config is for"
      t.string :display_name,
               null: false,
               comment: "A human-readable name"
      t.string :description,
               null: false,
               comment: "A description of this serving config's purpose"
      t.string :remote_resource_id,
               null: false,
               comment: "The ID of this serving config on Discovery Engine"

      t.timestamps

      t.index :remote_resource_id, unique: true
    end
  end
end
