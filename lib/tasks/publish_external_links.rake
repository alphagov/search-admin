desc "Ensure all external links in the database are present in rummager"
task publish_external_links: :environment do
  puts "Sending external links to rummager..."
  RecommendedLink.all.each do |link|
    puts "#{link.link}"
    RummagerLinkSynchronize.put(link)
  end
end
