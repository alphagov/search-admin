class Query < ActiveRecord::Base
  MATCH_TYPES = [
    "exact",
    "stemmed"
  ]

  validates :query, presence: true
  validates :match_type, inclusion: { in: MATCH_TYPES }

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
    bets.where(is_best: true)
  end

  def worst_bets
    bets.where(is_best: false)
  end
end
