class AddIndexToQuery < ActiveRecord::Migration[6.0]
  def change
    add_index :queries, [:query, :match_type], unique: true
  end
end
