class ImportCompletionDenylistWorker
  LOCK_NAME = "import_completion_denylist_worker".freeze

  include Sidekiq::Worker

  def perform
    CompletionDenylistEntry.with_advisory_lock(LOCK_NAME) do
      client.import(CompletionDenylistEntry.all)
    end
  end

private

  def client
    @client ||= DiscoveryEngine::CompletionDenylistClient.new
  end
end
