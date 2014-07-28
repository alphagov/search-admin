class Query < ActiveRecord::Base
  MATCH_TYPES = [
    "exact",
    "stemmed"
  ]

  validates :query, presence: true
  validates :match_type, inclusion: { in: MATCH_TYPES }
  validates :query, uniqueness: {scope: :match_type}

  has_many :bets, dependent: :destroy

  def self.to_csv(*args)
    CSV.generate do |csv|
      csv << ['query', 'link']

      all.each do |query|
        query.bets.each do |bet|
          csv << [query.query, bet.link]
        end
      end
    end
  end

  def best_bets
    bets.best
  end

  def worst_bets
    bets.worst
  end
end
