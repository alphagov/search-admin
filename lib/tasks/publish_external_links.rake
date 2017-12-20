desc "Ensure all external links in the database are present in the publishing platform"
namespace :publish_external_links do
  task rummager: :environment do
    puts "Sending external links to rummager..."
    RecommendedLink.all.each do |link|
      puts link.link
      RummagerLinkSynchronize.put(link)
    end
  end

  task publishing_api: :environment do
    puts "Sending external links to the publishing API..."
    RecommendedLink.all.each do |link|
      puts link.link
      ExternalContentPublisher.publish(link)
    end
  end
end
