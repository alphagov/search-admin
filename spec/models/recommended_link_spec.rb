require 'spec_helper'

describe RecommendedLink, 'validations' do
  it 'is invalid without a title attribute' do
    attributes = attributes_for(:recommended_link, title: nil)

    expect(new_recommended_link_with(attributes)).not_to be_valid
  end

  it "is invalid with a duplicate link" do
    create(:recommended_link, title: 'Tax', link: 'https://www.tax.service.gov.uk/', description: 'Self assessment', keywords: 'self, assessment, tax', search_index: 'mainstream')

    recommended_link = new_recommended_link_with(title: 'Tax', link: 'https://www.tax.service.gov.uk/', description: 'Self assessment', keywords: 'self, assessment, tax', search_index: 'mainstream')

    expect(recommended_link).to_not be_valid
  end

  it 'validates inclusion of search_index in RecommendedLink::SEARCH_INDEXES' do
    attributes = attributes_for(:recommended_link, search_index: 'not like the others')

    expect(new_recommended_link_with(attributes)).not_to be_valid
  end

  it "is valid with a search_index of 'mainstream'" do
    attributes = attributes_for(:recommended_link, search_index: 'mainstream')

    expect(new_recommended_link_with(attributes)).to be_valid
  end

  it "is valid with a search_index of 'government'" do
    attributes = attributes_for(:recommended_link, search_index: 'government')

    expect(new_recommended_link_with(attributes)).to be_valid
  end
end

def new_recommended_link_with(attributes)
  RecommendedLink.new(attributes)
end
