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
    permanent_and_inactive_bets_have_no_expiration_date
  end

  def permanent_and_inactive_bets_have_no_expiration_date
    if self.permanent || self.permanent.nil?
      self.expiration_date = nil
    end
  end

  def set_defaults
    if self.expiration_date.nil?
      self.expiration_date = default_expiration_date
      self.permanent = false
      self.save
    end
  end

  def default_expiration_date
    self.created_at.present? ? self.created_at + DEFAULT_VALIDITY : Time.zone.now + DEFAULT_VALIDITY
  end

  def set_created_at
    if self.created_at.nil?
      self.created_at =
        self.query.present? ? self.query.created_at : Time.zone.now
    end
  end

  def deactivate
    self.permanent = nil
    self.save!
  end

  def active?
    self.permanent || self.not_expired?
  end

  def self.active
    self.select(&:active?)
  end

  def not_expired?
    self.expiration_date.present? && self.expiration_date >= Time.zone.now
  end

  #to do: move into a view helper
  def valid_until
    if self.permanent
      "Permanent"
    elsif self.not_expired?
      "Expires #{self.expiration_date.strftime('%d %b %Y')}"
    else
      "Expired"
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
