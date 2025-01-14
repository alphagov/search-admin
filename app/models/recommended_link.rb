class RecommendedLink < ApplicationRecord
  include CsvExportable
  csv_fields :title, :link, :description, :keywords, :comment

  before_validation :generate_content_id, on: :create

  validates :title, :link, :description, :content_id, presence: true
  validates :link, uniqueness: { case_sensitive: true }, url: true
  validates :content_id, uniqueness: { case_sensitive: true }

private

  def generate_content_id
    self.content_id = SecureRandom.uuid
  end
end
