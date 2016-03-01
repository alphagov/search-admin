require 'spec_helper'

describe RummagerNotifier do
  describe '#call(changed_query_match_type_pairs)' do
    let(:query) { FactoryGirl.create(:query, query: 'jobs', match_type: 'exact') }

    it "`add`s an elasticsearch doc for existing queries" do
      query = FactoryGirl.create(:query, :with_best_bet, query: 'jobs', match_type: 'exact')

      es_doc_body = double(:es_doc_body)
      es_doc = double(:es_doc, body: es_doc_body)
      expect(ElasticSearchBet).to receive(:new)
        .with(query, include_id_and_type_in_body: true)
        .and_return(es_doc)

      RummagerNotifier.notify([%w(jobs exact)])

      expect(SearchAdmin.services(:rummager_index)).to have_received(:add).with(es_doc_body)
    end

    it "`delete`s the elasticsearch bet ID for deleted / altered queries" do
      es_doc_id = double(:es_doc_id)
      expect(ElasticSearchBetIDGenerator).to receive(:generate)
        .with('visas', 'exact')
        .and_return(es_doc_id)

      RummagerNotifier.notify([%w(visas exact)])

      expect(SearchAdmin.services(:rummager_index)).to have_received(:delete).with(es_doc_id, type: 'best_bet')
    end

    it "`delete`s the elasticsearch bet ID for queries with no bets" do
      es_doc_id = double(:es_doc_id)
      expect(ElasticSearchBetIDGenerator).to receive(:generate)
        .with('jobs', 'exact')
        .and_return(es_doc_id)

      RummagerNotifier.notify([%w(jobs exact)])

      expect(SearchAdmin.services(:rummager_index)).to have_received(:delete).with(es_doc_id, type: 'best_bet')
    end
  end
end
