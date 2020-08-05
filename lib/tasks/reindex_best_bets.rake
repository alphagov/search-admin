desc "Resend all local queries to search_api to be reindexed"
task reindex_best_bets: :environment do
  message = <<-MSG
    Rebuilding the elasticsearch index will just resend all locally stored best bets across to
    be inserted in to elasticsearch. This means that any orphaned entries in the elasticsearch
    index would still exist. This can be avoided by running the below rake task on Search-api
    before rebuilding the index.

    bundle exec rake search:switch_to_empty_index SEARCH_INDEX=metasearch
  MSG

  puts message

  puts "Starting to reindex #{Query.count} best bets in search_api"
  start = Time.zone.now.to_f

  Query.all.each do |query|
    puts "Processing: #{query.query} (#{query.match_type})"
    SearchApiSaver.new(query).save!
  end

  puts "Finished reindexing best bets in search_api (#{(Time.zone.now.to_f - start).round(2)} sec)"
end
