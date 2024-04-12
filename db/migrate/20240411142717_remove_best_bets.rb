class RemoveBestBets < ActiveRecord::Migration[7.1]
  def up
    drop_table :bets
    drop_table :queries
  end

  def down
    # It doesn't make sense to roll back beyond this point as we'll have deleted a lot of data and this is functionality
    # we are removing permanently from the app (future best bets functionality will have entirely different data as it
    # relates to a different search engine).
    raise ActiveRecord::IrreversibleMigration
  end
end
