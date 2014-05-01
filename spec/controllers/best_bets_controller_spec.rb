require 'spec_helper'

describe BestBetsController do
  describe "Creating best bets" do
    it "allows all expected fields to be set" do
      best_bet_params = {
        query: 'visas',
        match_type: 'exact',
        link: '/visas-and-immigration',
        position: 1,
        comment: 'Created to help UKVI',
        source: 'user_22'
      }

      post :create, best_bet: best_bet_params

      expect(BestBet.last.attributes.symbolize_keys).to include(best_bet_params)
    end
  end
end
