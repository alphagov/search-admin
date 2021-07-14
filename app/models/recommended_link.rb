class RecommendedLink < ApplicationRecord
  validates :title, :link, :description, :content_id, presence: true
  validates :link, uniqueness: { case_sensitive: true }, url: true
  validates :content_id, uniqueness: { case_sensitive: true }

  def format
    uri = URI(link)
    if uri.scheme.nil?
      uri = URI("https://#{link}")
    end

    if uri.host.casecmp("www.gov.uk").zero?
      "inside-government-link"
    else
      "recommended-link"
    end
  end

  def self.to_csv(*_args)
    CSV.generate do |csv|
      csv << %w[title link description keywords comment]

      all.find_each do |link|
        csv << [link.title,
                link.link,
                link.description,
                link.keywords,
                link.comment.to_s]
      end
    end
  end
end
