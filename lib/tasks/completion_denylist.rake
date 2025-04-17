namespace :completion_denylist do
  desc "Purge and re-import all completion denylist entries"
  task reimport: :environment do
    CompletionDenylist.sync(purge: true)
  end
end
