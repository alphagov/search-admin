class AddRecommendedLinks < ActiveRecord::Migration
  def change
    create_table :recommended_links do |t|
      t.string :title
      t.string :link
      t.string :description
      t.string :keywords
      t.string :search_index
      t.text :comment
      t.references :user
    end
  end
end
