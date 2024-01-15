desc "Ensure all external links in the database are present in the publishing platform"
namespace :publish_external_links do
  desc "Send external links to the Publishing API"
  task publishing_api: :environment do
    RecommendedLink.all.find_each do |link|
      puts link.link
      ExternalContentPublisher.publish(link)
    end
  end
end
