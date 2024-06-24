class Control < ApplicationRecord
  validates :display_name, presence: true
  validates :boost_amount, numericality: { greater_than_or_equal_to: -1, less_than_or_equal_to: 1 }
end
