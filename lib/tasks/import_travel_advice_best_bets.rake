require "csv"
require "travel_advice_bets_importer"

namespace :travel_advice do
  desc "Imports travel advice best bets into rummager from csv data."
  task :import_best_bets, %i[data_path user_name] => :environment do |_, args|
    data = CSV.read(args[:data_path])
    user = User.find_by(name: args[:user_name])
    raise "Search admin user name is required" unless user

    puts "Processing #{data.size} rows."

    importer = TravelAdviceBetsImporter.new(data, user)
    importer.import

    puts "Imported #{importer.count} best bets."
  end
end
