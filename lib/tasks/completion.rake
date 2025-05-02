namespace :completion do
  # This worker normally runs after changes are made to CompletionDenylistEntry records, but we may
  # want to run it manually, for example after a database import from a higher environment.
  desc "Trigger a denylist import to Discovery Engine"
  task import_denylist: :environment do
    # Run worker inline instead of async so we can get immediate feedback on any errors
    ImportCompletionDenylistWorker.new.perform
  end
end
