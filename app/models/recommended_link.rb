class RecommendedLink < ActiveRecord::Base
  SEARCH_INDEXES = %w(mainstream government)

  validates :title, :link, :description, :keywords, :search_index, presence: true
  validates :search_index, inclusion: { in: SEARCH_INDEXES }
  validates :link, uniqueness: true

  def self.to_csv(*_args)
    CSV.generate do |csv|
      csv << ['title', 'link', 'description', 'keywords', 'index', 'comment']

      all.each do |link|
        csv << [link.title,
                link.link,
                link.description,
                link.keywords,
                link.search_index,
                link.comment.to_s
              ]
      end
    end
  end
end
