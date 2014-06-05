require 'csv'

class Bet < ActiveRecord::Base
  belongs_to :user
  belongs_to :query

  validates :link, :query_id, :user_id, presence: true
  validates :position, numericality: {
                         allow_nil: true,
                         greater_than: 0,
                         only_integer: true
                       }

  def self.to_csv(*args)
    CSV.generate do |csv|
      csv << ['query', 'link']
      all.each do |best_bet|
        csv << [best_bet.query, best_bet.link]
      end
    end
  end
end
