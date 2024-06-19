class Boost < ApplicationRecord
  validates :name, :filter, presence: true
  validates :boost_amount, numericality: {
    greater_than_or_equal_to: -1.0, less_than_or_equal_to: 1.0
  }
end
