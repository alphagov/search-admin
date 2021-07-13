require "csv"

class Bet < ApplicationRecord
  DEFAULT_VALIDITY = 3.months.freeze

  belongs_to :user
  belongs_to :query

  scope :best,        -> { where(is_best: true) }
  scope :worst,       -> { where(is_best: false) }
  scope :impermanent, -> { where("permanent IS NULL OR NOT permanent") }

  attr_accessor :is_worst

  validates :expiration_date, bet_date: true
  validates :query_id, :user_id, presence: true
  validates :link, presence: true, bet_link: true
  validates :position,
            numericality: {
              allow_nil: false,
              greater_than: 0,
              less_than: 2_147_483_647, # Maximum value for integer
              only_integer: true,
            },
            if: :is_best?

  after_validation do
    permanent_and_inactive_bets_have_no_expiration_date
  end

  def permanent_and_inactive_bets_have_no_expiration_date
    if permanent || permanent.nil?
      self.expiration_date = nil
    end
  end

  def set_defaults
    if expiration_date.nil?
      self.expiration_date = default_expiration_date
      self.permanent = false
      if save
        true
      else
        false
      end
    end
  end

  def default_expiration_date
    created_at.present? ? created_at + DEFAULT_VALIDITY : Time.zone.now + DEFAULT_VALIDITY
  end

  def set_created_at
    if created_at.nil?
      self.created_at =
        query.present? ? query.created_at : Time.zone.now
    end
  end

  def deactivate
    self.permanent = nil
    save!
  end

  def active?
    permanent || not_expired?
  end

  def self.active
    self.select(&:active?)
  end

  def not_expired?
    expiration_date.present? && expiration_date >= Time.zone.now
  end

  # to do: move into a view helper
  def valid_until
    if permanent
      "Permanent"
    elsif not_expired?
      "Expires #{expiration_date.strftime('%d %b %Y')}"
    else
      "Expired"
    end
  end

  def is_query?
    false
  end

  def query_object
    query
  end
end
