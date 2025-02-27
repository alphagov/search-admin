# A document exclusion prevents a document from showing up in search results based on its link.
class DocumentExclusion < ApplicationRecord
  # The format links should take - this isn't a perfect regex but it's good enough for our purposes
  LINK_FORMAT = %r{\A(https?:/)?/.*\z}

  belongs_to :user

  before_validation :set_user

  validates :link, presence: true, uniqueness: true, format: { with: LINK_FORMAT }
  validates :comment, presence: true

private

  def set_user
    self.user ||= Current.user
  end
end
