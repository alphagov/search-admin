require 'spec_helper'

describe Bet do
  before do
    @valid_atts = {
      link: "/jobsearch",
      is_best: true,
      position: 1,
      comment: "Boost the most common job page to the top",
      user_id: 1,
      query_id: 1,
    }
  end

  it "can be created given valid attributes" do
    best_bet = Bet.new(@valid_atts)
    best_bet.save

    expect(best_bet).to be_valid
    expect(best_bet).to be_persisted
  end

  it "is invalid without a query" do
    best_bet = Bet.new(@valid_atts.merge(query_id: nil))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:query_id)
  end

  it "is invalid without a link" do
    best_bet = Bet.new(@valid_atts.merge(link: ""))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:link)
  end

  it "is valid without a comment" do
    best_bet = Bet.new(@valid_atts.merge(comment: ""))

    expect(best_bet).to be_valid
  end

  it "is invalid with a negative position" do
    best_bet = Bet.new(@valid_atts.merge(position: -2))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:position)
  end

  it "is invalid with a non-integer position" do
    best_bet = Bet.new(@valid_atts.merge(position: 3.5))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:position)
  end

  it "is valid with a nil position" do
    best_bet = Bet.new(@valid_atts.merge(position: nil))

    expect(best_bet).to be_valid
  end

  it "is invalid without a user_id" do
    best_bet = Bet.new(@valid_atts.merge(user_id: nil))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:user_id)
  end
end
