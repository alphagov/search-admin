class RecommendedLink < ActiveRecord::Base
  validates :title, :link, :description, :keywords, presence: true
  validates :link, uniqueness: true, url: true

  def format
    uri = URI(link)
    if uri.scheme.nil?
      uri = URI("https://" + link)
    end

    if uri.host.downcase == "www.gov.uk"
      'inside-government-link'
    else
      'recommended-link'
    end
  end

  def self.to_csv(*_args)
    CSV.generate do |csv|
      csv << %w(title link description keywords comment)

      all.each do |link|
        csv << [link.title,
                link.link,
                link.description,
                link.keywords,
                link.comment.to_s
              ]
      end
    end
  end
end
