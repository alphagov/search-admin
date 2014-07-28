require 'spec_helper'

describe QueriesController do
  let(:query_params) { {query: 'jobs', match_type: 'exact'} }

  describe '#create' do
    context 'on failure' do
      it "alerts the user" do
        post :create, query: query_params.merge(match_type: nil)
        expect(flash[:alert]).to include('could not create')
      end

      it "renders the new action" do
        post :create, query: query_params.merge(match_type: nil)
        expect(page).to render_template('new')
      end

      it "does not notify other systems" do
        post :create, query: query_params.merge(match_type: nil)
        expect(SearchAdmin.services(:message_bus)).not_to have_received(:notify)
      end
    end

    context 'on success' do
      it "notifies the user" do
        post :create, query: query_params
        expect(flash[:notice]).to include('was created')
      end

      it "redirects to the query" do
        post :create, query: query_params
        expect(page).to redirect_to(query_path(Query.last))
      end

      it "notifies the world of the new query" do
        post :create, query: query_params
        expect(SearchAdmin.services(:message_bus)).to have_received(:notify)
          .with(:bet_changed, [['jobs', 'exact']])
      end
    end

    it "converts the query to lower case" do
      post :create, query: query_params.merge(query: 'Jobs')
      expect(Query.last.query).to eq('jobs')
    end

    it "redirects to the existing query if duplicated" do
      existing_query = FactoryGirl.create(:query, query_params)
      post :create, query: query_params
      expect(page).to redirect_to(query_path(existing_query))
      expect(flash[:notice]).to include('exist')
    end
  end

  describe '#update' do
    let(:query) { FactoryGirl.create(:query, query: 'tax') }

    def update_query(options = {})
      put :update, id: query.id, query: query_params.merge(options)
    end

    context 'on failure' do
      it "alerts the user" do
        update_query(match_type: nil)
        expect(flash[:alert]).to include('could not update')
      end

      it "renders the edit action" do
        update_query(match_type: nil)
        expect(page).to render_template('edit')
      end

      it "does not notify other systems" do
        update_query(match_type: nil)
        expect(SearchAdmin.services(:message_bus)).not_to have_received(:notify)
      end
    end

    context 'on success' do
      it "notifies the user" do
        update_query
        expect(flash[:notice]).to include('was updated')
      end

      it "redirects to the query" do
        update_query
        expect(page).to redirect_to(query_path(Query.last))
      end

      it "notifies the world of the new query" do
        update_query
        expect(SearchAdmin.services(:message_bus)).to have_received(:notify)
          .with(:bet_changed, [['jobs', 'exact'], ['tax', 'exact']])
      end
    end

    it "converts the query to lower case" do
      update_query(query: 'Jobs')
      expect(Query.last.query).to eq('jobs')
    end
  end

  describe '#destroy' do
    let(:query) { FactoryGirl.create(:query, query: 'tax') }

    def delete_query
      delete :destroy, id: query.id
    end

    context 'on failure' do
      before do
        mock_query = double(:query, id: query.id, destroy: false)
        allow(Query).to receive(:find).with(query.id.to_s).and_return(mock_query)
      end

      it "alerts the user" do
        delete_query
        expect(flash[:alert]).to include('could not delete')
      end

      it "does not notify other systems" do
        delete_query
        expect(SearchAdmin.services(:message_bus)).not_to have_received(:notify)
      end
    end

    context 'on success' do
      it "notifies the user" do
        delete_query
        expect(flash[:notice]).to include('was deleted')
      end

      it "redirects to the query index" do
        delete_query
        expect(page).to redirect_to(queries_path)
      end

      it "notifies the world of the deletion" do
        delete_query
        expect(SearchAdmin.services(:message_bus)).to have_received(:notify)
          .with(:bet_changed, [['tax', 'exact']])
      end
    end
  end
end
