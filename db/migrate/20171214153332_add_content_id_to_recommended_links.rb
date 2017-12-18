class AddContentIdToRecommendedLinks < ActiveRecord::Migration[5.0]
  def up
    add_column :recommended_links, :content_id, "char(36)"
    add_index :recommended_links, :content_id, unique: true

    RecommendedLink.all.each do |link|
      link.update_attributes(content_id: SecureRandom.uuid())
    end
  end

  def down
    remove_column :recommended_links, :content_id
  end
end
