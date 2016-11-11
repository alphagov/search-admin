class ChangeRecommendedLinkTypes < ActiveRecord::Migration
  def change
    change_column :recommended_links, :description, :text
    change_column :recommended_links, :keywords, :text
  end
end
