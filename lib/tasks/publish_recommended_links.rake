desc "Ensure all recommended links in the database are present in Rummager"
task publish_recommended_links: :environment do
  puts "Sending recommended links to rummager..."
  RecommendedLink.all.each do |link|
    puts "#{link.link}"
    RummagerLinkSynchronize.put(link)
  end
end
