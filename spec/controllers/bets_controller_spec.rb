require 'spec_helper'

describe BetsController do
  let(:query) { FactoryGirl.create(:query) }
  let(:bet_params) {
    {
      query_id: query.id,
      link: '/visas-and-immigration',
      position: 1,
      comment: 'Created to help UKVI',
      is_best: true,
    }
  }

  describe "Creating bets" do
    it "allows all expected fields to be set" do
      post :create, bet: bet_params

      expect(Bet.last.attributes.symbolize_keys).to include(bet_params)
    end

    it "logs the user which created the bet" do
      user = FactoryGirl.create(:user)
      login_as(user)

      post :create, bet: bet_params

      expect(Bet.last.user_id).to eq(user.id)
    end

    it "marks the bet as manually created" do
      post :create, bet: bet_params

      expect(Bet.last).to be_manual
    end

    it "notifies the world of the change to the query" do
      post :create, bet: bet_params

      expect(SearchAdmin.services(:message_bus)).to have_received(:notify)
        .with(:bet_changed, [[query.query, query.match_type]])
    end

    it "redirects to the query show when create is successful" do
      post :create, bet: bet_params

      expect(flash[:notice]).to include('Bet created')
      expect(response).to redirect_to(query_path(query))
    end

    it "redirects to the query show when create is unsuccessful" do
      post :create, bet: bet_params.merge(link: '')

      expect(flash[:alert]).to include('could not be created')
      expect(response).to redirect_to(query_path(query))
    end
  end

  describe "Updating bets" do
    let(:bet) { query.bets.first }

    it "notifies the world of the change to the query" do
      put :update, id: bet.id, bet: bet_params

      expect(SearchAdmin.services(:message_bus)).to have_received(:notify)
        .with(:bet_changed, [[query.query, query.match_type]])
    end

    it "redirects to the query show when update is successful" do
      post :update, id: bet.id, bet: bet_params

      expect(flash[:notice]).to include('Bet updated')
      expect(response).to redirect_to(query_path(query))
    end

    it "renders the edit template when update is unsuccessful" do
      post :update, id: bet.id, bet: bet_params.merge(link: '')

      expect(flash[:alert]).to include('could not be saved')
      expect(response).to render_template(:edit)
    end
  end
end
