require "spec_helper"

describe BetsController do
  before do
    allow(Services.search_api).to receive(:add_document)
    allow(Services.search_api).to receive(:delete_document)
  end

  let(:query) { create(:query) }
  let(:bet_params) {
    {
      query_id: query.id,
      link: "/visas-and-immigration",
      position: 1,
      comment: "Created to help UKVI",
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

      expect(Services.search_api).to have_received(:add_document)
    end

    it "redirects to the query show when create is successful" do
      post :create, params: { bet: bet_params }

      expect(flash[:notice]).to include("Bet created")
      expect(response).to redirect_to(query_path(query))
    end

    it "redirects to the query show when create is unsuccessful" do
      post :create, params: { bet: bet_params.merge(link: "") }

      expect(flash[:alert]).to include("Error creating")
      expect(response).to redirect_to(query_path(query))
    end
  end

  describe "Updating bets" do
    let(:query) { create(:query, :with_best_bet) }
    let(:bet) { query.bets.first }

    it "notifies the world of the change to the query" do
      put :update, params: { id: bet.id, bet: bet_params }

      expect(Services.search_api).to have_received(:add_document)
    end

    it "does not notify the world to forget the query" do
      put :update, params: { id: bet.id, bet: bet_params }

      expect(Services.search_api).not_to have_received(:delete_document)
    end

    it "redirects to the query show when update is successful" do
      post :update, params: { id: bet.id, bet: bet_params }

      expect(flash[:notice]).to include("Bet updated")
      expect(response).to redirect_to(query_path(query))
    end

    it "renders the edit template when update is unsuccessful" do
      post :update, params: { id: bet.id, bet: bet_params.merge(link: "") }

      expect(flash[:alert]).to include("Error updating")
      expect(response).to render_template(:edit)
    end
  end

  describe "Deleting bets" do
    let(:query) { create(:query, :with_best_bet, query: "two words") }
    let(:bet) { query.bets.first }

    it "deleting the last bet will delete the query from Rummager" do
      expect(Services.search_api).to receive(:delete_document).with("two%20words-exact", "metasearch")

      delete :destroy, params: { id: bet.id }
    end

    it "deleting one of a group of bets bets will update the query in Rummager" do
      create(:bet, query: query)
      es_doc_id = ElasticSearchBetIDGenerator.generate(query.query, query.match_type)
      expect(Services.search_api).to receive(:add_document).with(es_doc_id, anything, "metasearch")

      delete :destroy, params: { id: bet.id }
    end
  end
end
