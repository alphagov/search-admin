class CreateQuery < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :query
      t.string :match_type
      t.timestamps
    end
  end
end
