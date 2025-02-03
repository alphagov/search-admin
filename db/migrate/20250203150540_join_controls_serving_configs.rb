class JoinControlsServingConfigs < ActiveRecord::Migration[8.0]
  def change
    create_join_table :controls, :serving_configs do |t|
      # NOTE: Search Admin uses MySQL, so we need to use a compound index over both columns rather
      # than the two individual indices the documentation recommends.
      t.index %i[control_id serving_config_id]
    end
  end
end
