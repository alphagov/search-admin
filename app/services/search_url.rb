class SearchUrl
  def self.for(search_term)
    base_url = Plek.new.website_root
    search_term = CGI.escape(search_term)
    random = SecureRandom.hex(10)
    "#{base_url}/search/all?keywords=#{search_term}&order=relevance&debug_score=1&cachebust=#{random}"
  end
end
