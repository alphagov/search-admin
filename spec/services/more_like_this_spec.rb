require 'spec_helper'

RSpec.describe MoreLikeThis do
  describe '.from_base_path' do
    context 'with an unknown base path in search' do
      before do
        allow(Services.rummager).to receive(:search)
          .with(
            filter_link: '/unknown',
            fields: ['taxons']
          )
          .and_return("results" => [])
      end

      it 'raises an custom not found exception' do
        expect { described_class.from_base_path('/unknown') }.to raise_error(
          MoreLikeThis::NotFoundInSearch
        )
      end
    end

    context 'with a content item without a taxon link' do
      before do
        allow(Services.rummager).to receive(:search)
          .with(
            filter_link: '/item',
            fields: ['taxons']
          )
          .and_return("results" => [
            'taxons' => []
          ])
      end

      it 'raises a custom not tagged to a taxon exception' do
        expect { described_class.from_base_path('/item') }.to raise_error(
          MoreLikeThis::NotTaggedToATaxon
        )
      end
    end

    context 'without any search results' do
      before do
        allow(Services.rummager).to receive(:search)
          .with(
            filter_link: '/item',
            fields: ['taxons']
          )
          .and_return("results" => [
            'taxons' => ['714bc7d1-afb0-4e10-9558-268da5dbbbba']
          ])

        allow(Services.rummager).to receive(:search)
          .with(
            hash_including(
              similar_to: '/item',
              filter_taxons: ['714bc7d1-afb0-4e10-9558-268da5dbbbba']
            )
          )
          .and_return('results' => [])
      end

      it 'raises a custom exception about no search results available' do
        expect { described_class.from_base_path('/item') }.to raise_error(
          MoreLikeThis::NoSearchResults
        )
      end
    end

    context 'with a valid base path with similar results' do
      before do
        allow(Services.rummager).to receive(:search)
          .with(
            filter_link: '/item',
            fields: ['taxons']
          )
          .and_return("results" => [
            'taxons' => ['714bc7d1-afb0-4e10-9558-268da5dbbbba']
          ])

        allow(Services.rummager).to receive(:search)
          .with(
            hash_including(
              similar_to: '/item',
              filter_taxons: ['714bc7d1-afb0-4e10-9558-268da5dbbbba']
            )
          )
          .and_return('results' => [
            {
              'link' => '/similar-item',
              'title' => 'Similar item',
              'es_score' => 20.97,
              'format' => 'detailed_guidance',
              'content_store_document_type' => 'detailed_guide'
            }
          ])
      end

      it 'returns an array of ElasticSearch more like this objects' do
        results = described_class.from_base_path('/item')

        expect(results.length).to eq(1)
        result = results.first

        expect(result).to be_a(ElasticSearchMltResult)
        expect(result.title).to eq('Similar item')
        expect(result.es_score).to eq(20.97)
        expect(result.link).to eq('/similar-item')
        expect(result.format).to eq('detailed_guidance')
        expect(result.content_store_document_type).to eq('detailed_guide')
      end
    end
  end
end
