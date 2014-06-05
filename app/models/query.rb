class Query < ActiveRecord::Base
  MATCH_TYPES = [
    "exact",
    "stemmed"
  ]

  validates :query, presence: true
  validates :match_type, inclusion: { in: MATCH_TYPES }

  has_many :bets

  def best_bets
    bets.where(is_best: true)
  end

  def worst_bets
    bets.where(is_best: false)
  end
end
