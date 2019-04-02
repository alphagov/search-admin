require 'spec_helper'

describe QueriesController do
  before do
    allow(Services.rummager).to receive(:add_document)
    allow(Services.rummager).to receive(:delete_document)
  end

  let(:query_params) { { query: 'jobs', match_type: 'exact' } }

  describe '#create' do
    context 'on failure' do
      it "alerts the user" do
        post :create, params: { query: query_params.merge(match_type: nil) }
        expect(flash[:alert]).to include('Error creating')
      end

      it "renders the new action" do
        post :create, params: { query: query_params.merge(match_type: nil) }
        expect(response).to render_template('new')
      end

      it "does not notify other systems" do
        post :create, params: { query: query_params.merge(match_type: nil) }
        expect(Services.rummager).not_to have_received(:add_document)
      end
    end

    context 'on success' do
      it "notifies the user" do
        post :create, params: { query: query_params }
        expect(flash[:notice]).to include('was created')
      end

      it "redirects to the query" do
        post :create, params: { query: query_params }
        expect(response).to redirect_to(query_path(Query.last))
      end

      it "does not notify the world of the new query - needs to wait for bets" do
        post :create, params: { query: query_params }
        expect(Services.rummager).not_to have_received(:add_document)
      end
    end

    it "converts the query to lower case" do
      post :create, params: { query: query_params.merge(query: 'Jobs') }
      expect(Query.last.query).to eq('jobs')
    end

    it "redirects to the existing query if duplicated" do
      existing_query = create(:query, query_params)
      post :create, params: { query: query_params }
      expect(response).to redirect_to(query_path(existing_query))
      expect(flash[:notice]).to include('exist')
    end
  end

  describe '#update' do
    let(:query) { create(:query, query: 'tax') }

    def update_query(options = {})
      put :update, params: { id: query.id, query: query_params.merge(options) }
    end

    context 'on failure' do
      it "alerts the user" do
        update_query(match_type: nil)
        expect(flash[:alert]).to include('Error updating')
      end

      it "renders the edit action" do
        update_query(match_type: nil)
        expect(response).to render_template('edit')
      end

      it "does not notify other systems" do
        update_query(match_type: nil)
        expect(Services.rummager).not_to have_received(:add_document)
      end
    end

    context 'on success' do
      it "notifies the user" do
        update_query
        expect(flash[:notice]).to include('was updated')
      end

      it "redirects to the query" do
        update_query
        expect(response).to redirect_to(query_path(Query.last))
      end

      context 'when query has bets' do
        before do
          create(:bet, query: query)
        end

        it "notifies the world to forget the previous query" do
          update_query
          expect(Services.rummager).to have_received(:delete_document)
            .with("#{query.query}-#{query.match_type}", any_args)
        end

        it "notifies the world of the new query" do
          update_query
          expect(Services.rummager).to have_received(:add_document)
            .with("#{query_params[:query]}-#{query_params[:match_type]}", any_args)
        end
      end

      context 'when query has no bets' do
        it "notifies the world of the new query" do
          update_query
          expect(Services.rummager).not_to have_received(:add_document)
        end
      end
    end

    it "converts the query to lower case" do
      update_query(query: 'Jobs')
      expect(Query.last.query).to eq('jobs')
    end
  end

  describe '#destroy' do
    let(:query) { create(:query, query: 'tax') }

    def delete_query
      delete :destroy, params: { id: query.id }
    end

    context 'on failure' do
      before do
        mock_query = double(:query, id: query.id)
        allow(mock_query).to receive(:destroy!).and_raise(ActiveRecord::ActiveRecordError)
        allow(Query).to receive(:find).with(query.id.to_s).and_return(mock_query)
      end

      it "alerts the user" do
        delete_query
        expect(flash[:alert]).to include('Error deleting')
      end

      it "does not notify other systems" do
        delete_query
        expect(Services.rummager).not_to have_received(:delete_document)
      end
    end

    context 'on success' do
      it "notifies the user" do
        delete_query
        expect(flash[:notice]).to include('was deleted')
      end

      it "redirects to the query index" do
        delete_query
        expect(response).to redirect_to(queries_path)
      end

      it "notifies the world of the deletion" do
        delete_query
        expect(Services.rummager).to have_received(:delete_document)
      end
    end
  end
end
