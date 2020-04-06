class AddIndexToRecommendedLink < ActiveRecord::Migration[6.0]
  def change
    add_index :recommended_links, :link, unique: true
  end
end
