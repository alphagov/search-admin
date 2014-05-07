require 'csv'

class BestBet < ActiveRecord::Base
  def self.to_csv(*args)
    CSV.generate do |csv|
      csv << ['query', 'link']
      all.each do |best_bet|
        csv << [best_bet.query, best_bet.link]
      end
    end
  end
end
