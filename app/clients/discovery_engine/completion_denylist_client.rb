module DiscoveryEngine
  # Client to synchronise completion denylist entries to Discovery Engine
  #
  # Discovery Engine does not support operating on individual denylist entries, instead any changes
  # to existing items on the denylist require a full import.
  #
  # This client's operations are normally asynchronous, but it intentionally blocks while waiting
  # for a result to make error reporting easier. It should only be used in a background job or
  # scheduled task.
  class CompletionDenylistClient
    include DiscoveryEngine::Services

    # Imports a list/scope of `CompletionDenylistEntry` records to Discovery Engine
    def import(completion_denylist_entries)
      operation = completion_service.import_suggestion_deny_list_entries(
        inline_source: {
          # This isn't the most efficient way of doing this, but given that the current maximum
          # number of denylist entries in Discovery Engine is the same as `#find_each`'s default
          # batch size (1000), it's not the end of the world even if we pass in the whole of
          # `DenylistEntry` as a scope.
          #
          # If that ever goes up by an order of magnitude, we should consider making this more
          # efficient, for example by selecting the required columns instead of dealing with
          # ActiveRecord objects.
          entries: completion_denylist_entries.map(
            &:to_discovery_engine_completion_denylist_entry
          ),
        },
        parent: DataStore.default.name,
      )

      operation.wait_until_done!
      raise operation.results.message if operation.error?

      failed = operation.results.failed_entries_count
      imported = operation.results.imported_entries_count
      if failed.positive?
        raise "Failed to import #{failed} entries to completion denylist (#{imported} succeeded)"
      end

      Rails.logger.info("Successfully imported #{imported} entries to completion denylist")
    end
  end
end
