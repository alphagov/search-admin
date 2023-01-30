require "active_support"
require "sidekiq-scheduler"

class ExpiredBetWorker
  include Sidekiq::Worker

  def perform
    recently_expired_bets.find_each do |bet|
      SearchApiSaver.new(bet).destroy(action: :deactivate)
    end
  end

private

  # job runs every hour but checks for bets which expired in the last
  # 90 minutes - this is to reduce the chance of something being
  # missed due to jitter in job start time.
  def recently_expired_bets
    Bet.impermanent.where(
      "expiration_date IS NOT NULL AND expiration_date >= ? AND expiration_date <= ?",
      90.minutes.ago,
      Time.zone.now,
    )
  end
end
