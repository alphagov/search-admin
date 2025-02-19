desc "Ensure all external links in the database are present in the publishing platform"
namespace :publish_external_links do
  desc "Send external links to the Publishing API"
  task publishing_api: :environment do
    client = PublishingApi::ContentItemClient.new

    RecommendedLink.all.find_each do |link|
      puts link.link
      client.create(link) # rubocop:disable Rails/SaveBang (not an ActiveRecord object)
    end
  end
end
