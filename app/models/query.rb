class Query < ApplicationRecord
  MATCH_TYPES = %w(exact stemmed).freeze

  validates :query, presence: true
  validates :match_type, inclusion: { in: MATCH_TYPES }
  validates :query, uniqueness: { scope: :match_type, case_sensitive: true }

  has_many :bets, dependent: :destroy
  has_many :best_bets, -> { best }, class_name: "Bet"
  has_many :worst_bets, -> { worst }, class_name: "Bet"

  # Use `sort_by` to prevent N+1 queries when Queries are loaded in a list.
  def sorted_best_bets
    best_bets.sort_by(&:position)
  end

  def display_name
    "#{query} (#{match_type})"
  end

  def is_query?
    true
  end

  def query_object
    self
  end

  def self.to_csv(*_args)
    CSV.generate do |csv|
      csv << ["query", "match_type", "link", "best/worst", "comment"]

      all.includes(:bets).find_each do |query|
        query.bets.each do |bet|
          csv << [query.query,
                  query.match_type,
                  bet.link,
                  bet.is_best ? "best" : "worst",
                  bet.comment.to_s]
        end
      end
    end
  end
end
