require 'spec_helper'

describe BestBetsController do
  let(:best_bet_params) {
    {
      query: 'visas',
      match_type: 'exact',
      link: '/visas-and-immigration',
      position: 1,
      comment: 'Created to help UKVI'
    }
  }

  describe "Creating best bets" do
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

    it "notifies the world of the change" do
      post :create, best_bet: best_bet_params

      notification_params = best_bet_params.slice(:query, :match_type, :link, :position)

      expect(SearchAdmin.services(:message_bus)).to have_received(:notify).with(:best_bet_changed, notification_params)
    end
  end

  describe "Updating best bets" do
    let(:best_bet) { FactoryGirl.create(:best_bet) }

    it "notifies the world of the change" do
      put :update, id: best_bet.id, best_bet: best_bet_params

      notification_params = best_bet_params.slice(:query, :match_type, :link, :position)

      expect(SearchAdmin.services(:message_bus)).to have_received(:notify).with(:best_bet_changed, notification_params)
    end
  end
end
