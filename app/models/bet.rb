require 'csv'

class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :query

  attr_accessor :is_worst

  validates :link, :query_id, :user_id, presence: true
  validates :position, numericality: {
                         allow_nil: false,
                         greater_than: 0,
                         less_than: 2147483647, # Maximum value for integer
                         only_integer: true
                       }, if: :is_best?

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
