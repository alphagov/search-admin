require "csv"

class Bet < ApplicationRecord
  DEFAULT_VALIDITY = 3.months.freeze

  belongs_to :user
  belongs_to :query

  attr_accessor :is_worst
  validates :expiration_date, bet_date: true
  validates :query_id, :user_id, presence: true
  validates :link, presence: true, bet_link: true
  validates :position, numericality: {
                         allow_nil: false,
                         greater_than: 0,
                         less_than: 2147483647, # Maximum value for integer
                         only_integer: true,
                       }, if: :is_best?

  after_validation do
    self.expiration_date = nil if self.permanent
  end
  
  def set_default_expiration_date
    self.expiration_date =
      self.created_at.present? ? self.created_at + DEFAULT_VALIDITY : Time.zone.now + DEFAULT_VALIDITY
  end

  def set_created_at
    if self.created_at.nil?
      self.created_at =
        self.query.present? ? self.query.created_at : Time.zone.now
    end
  end

  def self.best
    where(is_best: true)
  end

  def self.worst
    where.not(is_best: true)
  end

  def is_query?
    false
  end

  def query_object
    self.query
  end
end
