namespace "sync" do
  desc "Ensure all recommended links in the db are present in rummager"
  task "recommended-links" => :environment do
    puts "Sending recommended links to rummager..."
    RecommendedLink.all.each do |link|
      puts "#{link.link}"
      RummagerLinkSynchronize.put(link)
    end
  end
end
