require 'spec_helper'

describe Query, 'associations' do
  it 'should destroy associated bets on #destroy' do
    query = FactoryGirl.create :query
    bets = query.bets

    query.destroy

    expect(bets).to eq []
  end
end
