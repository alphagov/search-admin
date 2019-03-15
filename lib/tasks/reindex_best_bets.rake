desc "Resend all local queries to rummager to be reindexed"
task reindex_best_bets: :environment do
  message = <<-MSG
    Rebuilding the elasticsearch index will just resend all locally stored best bets across to
    be inserted in to elasticsearch. This means that any orphaned entries in the elasticsearch
    index would still exist. This can be avoided by running the below rake task on Rummager
    before rebuilding the index.

    bundle exec rake rummager:switch_to_empty_index RUMMAGER_INDEX=metasearch
  MSG

  puts message

  puts "Starting to reindex #{Query.count} best bets in rummager"
  start = Time.now.to_f

  Query.all.each do |query|
    puts "Processing: #{query.query} (#{query.match_type})"
    RummagerSaver.new(query).update_elasticsearch(:create_or_update)
  end

  puts "Finished reindexing best bets in rummager (#{(Time.now.to_f - start).round(2)} sec)"
end
