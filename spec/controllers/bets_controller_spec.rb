require 'spec_helper'

describe BetsController do
  before do
    allow(RummagerNotifier).to receive(:notify)
  end

  let(:query) { create(:query) }
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
      post :create, params: { bet: bet_params }

      expect(Bet.last.attributes.symbolize_keys).to include(bet_params)
    end

    it "logs the user which created the bet" do
      user = create(:user)
      login_as(user)

      post :create, params: { bet: bet_params }

      expect(Bet.last.user_id).to eq(user.id)
    end

    it "marks the bet as manually created" do
      post :create, params: { bet: bet_params }

      expect(Bet.last).to be_manual
    end

    it "notifies the world of the change to the query" do
      post :create, params: { bet: bet_params }

      expect(RummagerNotifier).to have_received(:notify)
        .with([[query, :create]])
    end

    it "redirects to the query show when create is successful" do
      post :create, params: { bet: bet_params }

      expect(flash[:notice]).to include('Bet created')
      expect(response).to redirect_to(query_path(query))
    end

    it "redirects to the query show when create is unsuccessful" do
      post :create, params: { bet: bet_params.merge(link: '') }

      expect(flash[:alert]).to include('could not be created')
      expect(response).to redirect_to(query_path(query))
    end
  end

  describe "Updating bets" do
    let(:query) { create(:query, :with_best_bet) }
    let(:bet) { query.bets.first }

    it "notifies the world of the change to the query" do
      put :update, params: { id: bet.id, bet: bet_params }

      expect(RummagerNotifier).to have_received(:notify)
        .with([[query, :update]])
    end

    it "redirects to the query show when update is successful" do
      post :update, params: { id: bet.id, bet: bet_params }

      expect(flash[:notice]).to include('Bet updated')
      expect(response).to redirect_to(query_path(query))
    end

    it "renders the edit template when update is unsuccessful" do
      post :update, params: { id: bet.id, bet: bet_params.merge(link: '') }

      expect(flash[:alert]).to include('could not be saved')
      expect(response).to render_template(:edit)
    end
  end
end
