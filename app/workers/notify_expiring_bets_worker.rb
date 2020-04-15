class NotifyExpiringBetsWorker
  THRESHOLD = 7.days

  include Sidekiq::Worker

  def perform
    addresses.each do |address|
      BetsMailer.new.expiring_bets_list(address, soon_to_expire_bets).deliver_now
    end

    # also notify bet creators (if they're not in the 'addresses'
    # list).
    grouped_bets = soon_to_expire_bets.each_with_object({}) do |bet, grouped|
      address = bet.user.email
      next if addresses.include? address

      grouped[address] ||= []
      grouped[address] << bet
    end
    grouped_bets.each do |address, bets|
      BetsMailer.new.expiring_bets_list(address, bets).deliver_now
    end
  end

private

  def addresses
    ENV.fetch("EXPIRING_BETS_MAILING_LIST", "").split(",")
  end

  def soon_to_expire_bets
    @soon_to_expire_bets ||= Bet.impermanent.where(expiration_date: DateTime.now.beginning_of_day + THRESHOLD)
  end
end
