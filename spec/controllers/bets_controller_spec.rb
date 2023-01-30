require "spec_helper"

describe BetsController do
  before do
    allow(Services.search_api).to receive(:add_document)
    allow(Services.search_api).to receive(:delete_document)
  end

  let(:query) { create(:query) }

  let(:permanent_bet_params) do
    {
      query_id: query.id,
      link: "/visas-and-immigration",
      position: 1,
      comment: "Created to help UKVI",
      is_best: true,
      permanent: "1",
    }
  end

  describe "Creating bets" do
    context "when logged in as an admin user" do
      before do
        @admin_user = create(:admin_user)
        login_as(@admin_user)
      end

      it "allows all expected fields to be set" do
        post :create, params: { bet: permanent_bet_params }
        attrs = permanent_bet_params.merge(permanent: true)
        expect(Bet.last.attributes.symbolize_keys).to include(attrs)
      end

      it "logs the user which created the bet" do
        post :create, params: { bet: permanent_bet_params }

        expect(Bet.last.user_id).to eq(@admin_user.id)
      end

      it "marks the bet as manually created" do
        post :create, params: { bet: permanent_bet_params }

        expect(Bet.last).to be_manual
      end

      it "notifies the world of the change to the query" do
        post :create, params: { bet: permanent_bet_params }

        expect(Services.search_api).to have_received(:add_document)
      end

      it "redirects to the query show when create is successful" do
        post :create, params: { bet: permanent_bet_params }

        expect(flash[:notice]).to include("Bet created")
        expect(response).to redirect_to(query_path(query))
      end

      describe "redirects and shows errors when create is unsuccessful" do
        it "no links entered" do
          post :create, params: { bet: permanent_bet_params.merge(link: "") }

          expect(flash[:alert]).to include("Error creating")
          expect(response).to redirect_to(query_path(query))
        end

        it "invalid or empty expiration date" do
          post :create, params: { bet: permanent_bet_params.merge(permanent: "") }

          expect(flash[:alert]).to include("Error creating")
          expect(response).to redirect_to(query_path(query))
        end
      end
    end

    context "when logged in as a basic signin user" do
      before do
        @user = create(:user)
        login_as(@user)
      end

      it "allows all expected fields to be set" do
        post :create, params: { bet: permanent_bet_params.merge(permanent: "") }
        attrs = permanent_bet_params.merge(permanent: false)
        expect(Bet.last.attributes.symbolize_keys).to include(attrs)
        expect(Bet.last.expiration_date).to eq Bet.last.created_at + 3.months
      end
    end
  end

  describe "Updating bets" do
    let(:query) { create(:query, :with_best_bet) }
    let(:bet) { query.bets.first }

    context "when logged in as an admin user" do
      before do
        @admin_user = create(:admin_user)
        login_as(@admin_user)
      end
      it "notifies the world of the change to the query" do
        put :update, params: { id: bet.id, bet: permanent_bet_params }

        expect(Services.search_api).to have_received(:add_document)
      end

      it "does not notify the world to forget the query" do
        put :update, params: { id: bet.id, bet: permanent_bet_params }

        expect(Services.search_api).not_to have_received(:delete_document)
      end

      it "redirects to the query show when update is successful" do
        post :update, params: { id: bet.id, bet: permanent_bet_params }

        expect(flash[:notice]).to include("Bet updated")
        expect(response).to redirect_to(query_path(query))
      end

      describe "unsuccessful updates render the edit page" do
        it "no link" do
          post :update, params: { id: bet.id, bet: permanent_bet_params.merge(link: "") }

          expect(flash[:alert]).to include("Error updating")
          expect(response).to render_template(:edit)
        end

        it "no expiration date for a temporary bet" do
          post :update, params: { id: bet.id, bet: permanent_bet_params.merge(expiration_date: "", permanent: "") }
          expect(flash[:alert]).to include("Error updating")
          expect(response).to render_template(:edit)
        end
      end
    end
    context "when logged in as a basic signin user" do
      before do
        @user = create(:user)
        login_as(@user)
      end
      it "is not possible to update the expiration date" do
        post :update, params: { id: bet.id, bet: permanent_bet_params }
        expect(Bet.last.attributes.symbolize_keys).not_to include(permanent: true)
      end
    end
  end

  describe "Reactivating bets" do
    let(:query) { create(:query, :with_best_bet) }
    let(:bet) { query.bets.first }

    context "when logged in as a basic signin user" do
      before do
        bet.deactivate
        @user = create(:user)
        login_as(@user)
      end

      it "notifies the world of the change to the query" do
        post :update, params: { id: bet.id, bet: permanent_bet_params.merge(active: "true") }
        expect(Services.search_api).to have_received(:add_document)
        expect(Bet.find(bet.id)).to be_active
        expect(Bet.find(bet.id).permanent).to be false
      end

      it "does not notify the world to forget the query" do
        put :update, params: { id: bet.id, bet: permanent_bet_params }
        expect(Services.search_api).not_to have_received(:delete_document)
      end

      it "redirects to the query show when update is successful" do
        post :update, params: { id: bet.id, bet: permanent_bet_params.merge(active: "true") }

        expect(flash[:notice]).to include("Bet reactivated")
        expect(response).to redirect_to(query_path(query))
      end
    end
  end

  describe "Deactivating bets" do
    let(:query) { create(:query, :with_best_bet, query: "two words") }
    let(:bet) { query.bets.first }

    it "redirects to the query show when the bet has been deactivated" do
      post :deactivate, params: { id: bet.id, bet: permanent_bet_params }
      expect(flash[:notice]).to include("Bet deactivated")
      expect(response).to redirect_to(query_path(query))
    end

    it "deactivating the last bet will delete the query from Search API" do
      expect(Services.search_api).to receive(:delete_document).with("two%20words-exact", "metasearch")
      post :deactivate, params: { id: bet.id }
    end

    it "deactivating one of a group of best bets will update the query in Search-api" do
      create(:bet, query:)
      es_doc_id = ElasticSearchBetIDGenerator.generate(query.query, query.match_type)
      expect(Services.search_api).to receive(:add_document).with(es_doc_id, anything, "metasearch")

      post :deactivate, params: { id: bet.id }
    end
  end

  describe "Deleting bets" do
    let(:query) { create(:query, :with_best_bet, query: "two words") }
    let(:bet) { query.bets.first }

    it "deleting the last bet will delete the query from Search-api" do
      expect(Services.search_api).to receive(:delete_document).with("two%20words-exact", "metasearch")

      delete :destroy, params: { id: bet.id }
    end

    it "deleting one of a group of best bets will update the query in Search-api" do
      create(:bet, query:)
      es_doc_id = ElasticSearchBetIDGenerator.generate(query.query, query.match_type)
      expect(Services.search_api).to receive(:add_document).with(es_doc_id, anything, "metasearch")

      delete :destroy, params: { id: bet.id }
    end
  end

  context "when logged in as an admin user" do
    before do
      admin_user = create(:admin_user)
      login_as(admin_user)
    end

    it "redirects to the query show when creating a permanent bet" do
      post :create, params: { bet: permanent_bet_params.merge(permanent: "1") }

      expect(flash[:notice]).to include("Bet created")
      expect(response).to redirect_to(query_path(query))
      expect(Bet.last).to be_permanent
    end
  end
end
