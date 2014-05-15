require 'csv'

class BestBet < ActiveRecord::Base
  MATCH_TYPES = [
    "exact",
    "stemmed"
  ]

  belongs_to :user

  validates :query, :link, :user_id, presence: true
  validates :match_type, inclusion: { in: MATCH_TYPES }
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
