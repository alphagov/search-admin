class AddQueryIdToBets < ActiveRecord::Migration
  def change
    add_column :bets, :query_id, :integer
    add_column :bets, :is_best, :boolean, default: true

    Bet.all.each do |bet|
      query = Query.where(query: bet['query'], match_type: bet['match_type']).first
      query ||= Query.create!(query: bet['query'], match_type: bet['match_type'])

      bet.update_attributes(is_best: bet.position.present?, query_id: query.id)
    end

    remove_column :bets, :query, :string
    remove_column :bets, :match_type, :string
  end
end
