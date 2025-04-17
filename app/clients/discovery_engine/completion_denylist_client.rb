module DiscoveryEngine
  # Client to synchronize `DenylistEntry` records  with Discovery Engine
  #
  # Note that this client blocks on its operations to ensure purges fully complete before imports,
  # and that we are aware of any errors that occur. Denylist operations are usually reasonably
  # quick, but we still shouldn't do this as part of synchronous user flows and use background
  # workers instead.
  class CompletionDenylistClient
    include DiscoveryEngine::Services

    # Import a list of denylist entries into Discovery Engine
    def import(denylist_entries)
      operation = completion_service.import_suggestion_deny_list_entries(
        inline_source: {
          entries: denylist_entries.map(&:to_discovery_engine_completion_denylist_entry),
        },
        parent: DataStore.default.name,
      )
      operation.wait_until_done! do |response|
        results = response.results
        raise results.message if response.error?
        raise "#{results.imported_entries_count} entries imported, but #{results.failed_entries_count} failed" if results.failed_entries_count.positive?

        Rails.logger.info("Imported #{results.imported_entries_count} denylist entries into Discovery Engine")
      end
    end

    # Purge all denylist entries from Discovery Engine
    def purge
      operation = completion_service.purge_suggestion_deny_list_entries(
        parent: DataStore.default.name,
      )
      operation.wait_until_done! do |response|
        results = response.results
        raise results.message if response.error?

        Rails.logger.info("Purged #{results.purge_count} denylist entries from Discovery Engine")
      end
    end
  end
end
