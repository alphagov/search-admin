require 'spec_helper'

describe BestBetsController do
  describe "Creating best bets" do
    let(:best_bet_params) {
      {
        query: 'visas',
        match_type: 'exact',
        link: '/visas-and-immigration',
        position: 1,
        comment: 'Created to help UKVI'
      }
    }

    it "allows all expected fields to be set" do
      post :create, best_bet: best_bet_params

      expect(BestBet.last.attributes.symbolize_keys).to include(best_bet_params)
    end

    it "logs the user which created the best bet" do
      user = FactoryGirl.create(:user)
      login_as(user)

      post :create, best_bet: best_bet_params

      expect(BestBet.last.user_id).to eq(user.id)
    end

    it "marks the best bet as manually created" do
      post :create, best_bet: best_bet_params

      expect(BestBet.last).to be_manual
    end
  end
end
