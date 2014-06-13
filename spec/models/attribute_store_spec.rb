require 'spec_helper'

describe AttributeStore, '#add_previous_attributes' do
  it 'holds a reference to a set of previous attributes for a query' do
    query = FactoryGirl.build_stubbed :query

    attribute_store = AttributeStore.new
    attribute_store.add_previous_attributes_for(query)

    expect(attribute_store.previous_attributes).to eq [query.query, query.match_type]
  end
end

describe AttributeStore, '#add_updated_attributes' do
  it 'holds a reference to a set of updated attributes for a query' do
    query = FactoryGirl.build_stubbed :query

    attribute_store = AttributeStore.new
    attribute_store.add_updated_attributes_for(query)

    expect(attribute_store.updated_attributes).to eq [query.query, query.match_type]
  end
end

describe AttributeStore, '#attributes' do
  context 'if only updated attributes are present' do
    it 'returns an array containing the updated attributes array' do
      query = FactoryGirl.build_stubbed :query

      attribute_store = AttributeStore.new
      attribute_store.add_updated_attributes_for(query)

      expect(attribute_store.attributes).to eq [[query.query, query.match_type]]
    end
  end

  context 'if there are previous and updated attributes present' do
    it 'returns an array containing the updated attributes array and the previous attributes array' do
      query = FactoryGirl.build_stubbed :query
      updated_query = FactoryGirl.build_stubbed :query

      attribute_store = AttributeStore.new
      attribute_store.add_previous_attributes_for(query)
      attribute_store.add_updated_attributes_for(updated_query)

      expect(attribute_store.attributes).to eq [[updated_query.query, updated_query.match_type], [query.query, query.match_type]]
    end
  end
end
