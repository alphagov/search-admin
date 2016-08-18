require 'csv'

namespace "csv" do
  desc "Import a CSV file with recommended links into the search-admin database"
  task "import" => :environment do
    filename = ENV["filename"]
    links = []

    fail "The file #{filename} does not exist." unless File.exist?(filename)

    CSV.foreach(filename, encoding: "UTF-8", headers: true) do |row|
      next if row.empty?

      puts "Creating recommended link for #{row[0]}"
      link = RecommendedLink.new(
        title: row[0],
        link: row[1],
        description: row[2],
        keywords: row[3]
      )

      if link.valid?
        links.push link
      else
        fail "Error(s) on line #{$.} of the CSV file: #{link.errors.messages}"
      end
    end

    puts "Saving all recommended links to the database"
    RecommendedLink.transaction do
      links.each(&:save!)
    end
  end
end
