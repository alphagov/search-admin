require 'spec_helper'

describe RecommendedLink do
  it "uses recommended-link format if it is external to gov.uk" do
    recommended_link = create(
      :recommended_link,
      link: "https://www.google.com"
    )
    expect(recommended_link.format).to eq "recommended-link"
  end

  it "uses inside-government-link format if it is internal to gov.uk" do
    recommended_link = create(
      :recommended_link,
      link: "https://www.gov.uk/bank-holidays"
    )
    expect(recommended_link.format).to eq "inside-government-link"
  end

  it "uses recommended-link format if it is external to gov.uk but has a gov.uk domain" do
    recommended_link = create(
      :recommended_link,
      link: "https://www.free-ice-cream.gov.uk"
    )
    expect(recommended_link.format).to eq "recommended-link"
  end
end

describe RecommendedLink, 'validations' do
  it 'is invalid without a title attribute' do
    attributes = attributes_for(:recommended_link, title: nil)

    expect(new_recommended_link_with(attributes)).not_to be_valid
  end

  it "is invalid with a duplicate link" do
    create(:recommended_link, title: 'Tax', link: 'https://www.tax.service.gov.uk/', description: 'Self assessment', keywords: 'self, assessment, tax')

    recommended_link = new_recommended_link_with(title: 'Tax', link: 'https://www.tax.service.gov.uk/', description: 'Self assessment', keywords: 'self, assessment, tax')

    expect(recommended_link).to_not be_valid
  end
end

def new_recommended_link_with(attributes)
  RecommendedLink.new(attributes)
end
