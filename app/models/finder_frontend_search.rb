# Represents a search on Finder Frontend.
#
# This is used to build URLs for previewing various changes across Search Admin, such as recommended
# links.
class FinderFrontendSearch
  def self.for_keywords(keywords)
    new(keywords:)
  end

  attr_reader :url

  def initialize(query_params)
    query_params = query_params.merge(
      # Add a random parameter to bypass CDN caching
      cachebust: SecureRandom.hex(10),
    )

    url = URI.join(Plek.new.website_root, "search/all")
    url.query = query_params.to_query
    @url = url.to_s
  end
end
