# External links to council homepages are now published and managed
# by Local Links Manager.
namespace :once_off do
  desc "Unpublish all external links that are council homepages"
  task remove_council_external_links: :environment do
    non_councils = [
      "Corporation of London",
      "Comhairle nan Eilean Siar",
      "City and County of Swansea",
    ]

    council_links = RecommendedLink.where("title LIKE '%Council%'") + RecommendedLink.where(title: non_councils)
    council_links.each do |link|
      ExternalContentPublisher.unpublish(link)
      link.destroy!
    end
  end
end
