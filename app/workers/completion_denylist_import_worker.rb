class CompletionDenylistSyncWorker
  include Sidekiq::Worker

  def perform(id_or_ids)
    ids = Array(id_or_ids)
    CompletionDenylistEntry.where(id: ids).sync
  end
end
