require 'csv'

class Bet < ActiveRecord::Base
  belongs_to :user
  belongs_to :query

  validates :link, :query_id, :user_id, presence: true
  validates :position, numericality: {
                         allow_nil: false,
                         greater_than: 0,
                         only_integer: true
                       }, if: :is_best?
end
