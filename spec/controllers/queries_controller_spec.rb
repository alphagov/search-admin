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
  end
end
