require "active_support"
require "sidekiq-scheduler"

class DeleteOldBetsWorker
  # All expired bets older than this, or all disabled bets last
  # updated longer ago than this, are deleted
  OLD_BET_THRESHOLD = 30.days

  include Sidekiq::Worker

  def perform
    queries = old_expired_bets.map(&:query_id).uniq + old_disabled_bets.map(&:query_id).uniq

    old_expired_bets.delete_all
    old_disabled_bets.delete_all

    # remove empty queries from search-api to avoid cruft in the index
    queries.each do |qid|
      q = Query.find(qid)
      SearchApiSaver.new(q).destroy(action: :delete) if q.bets.empty?
    end
  end

private

  def old_expired_bets
    Bet.impermanent.where(
      "expiration_date IS NOT NULL AND expiration_date <= ?",
      OLD_BET_THRESHOLD.ago,
    )
  end

  def old_disabled_bets
    Bet.impermanent.where(
      "expiration_date IS NULL AND ((updated_at IS NULL AND created_at <= ?) OR (updated_at IS NOT NULL AND updated_at <= ?))",
      OLD_BET_THRESHOLD.ago,
      OLD_BET_THRESHOLD.ago,
    )
  end
end
