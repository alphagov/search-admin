class RecommendedLink < ApplicationRecord
  include CsvExportable
  csv_fields :title, :link, :description, :keywords, :comment

  include RemoteSynchronizable
  self.remote_synchronizable_client_class = PublishingApi::ContentItemClient

  before_validation :generate_content_id, on: :create

  validates :title, :link, :description, :content_id, presence: true
  validates :link, uniqueness: { case_sensitive: true }, url: true
  validates :content_id, uniqueness: { case_sensitive: true }

  # A URL to preview this recommended link by searching for its title on Finder Frontend
  def preview_url
    FinderFrontendSearch.for_keywords(title).url
  end

  # A hash representing a Publishing API content item for this recommended link
  def to_publishing_api_content_item
    {
      title:,
      description:,
      details: {
        hidden_search_terms: [keywords].compact,
        url: link,
      },
      document_type: "external_content",
      publishing_app: "search-admin",
      schema_name: "external_content",
      update_type: "major",
    }
  end

private

  def generate_content_id
    self.content_id = SecureRandom.uuid
  end
end
