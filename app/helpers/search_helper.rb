module SearchHelper
  def search_url_for_keyword(keyword)
    query_params = {
      order: "relevance",
      debug_score: 1,
      cachebust: SecureRandom.hex(10),
      keywords: keyword,
    }

    URI.join(Plek.new.website_root, "/search/all?#{query_params.to_query}").to_s
  end
end
