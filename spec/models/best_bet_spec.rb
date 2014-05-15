require 'spec_helper'

describe BestBet do
  before do
    @valid_atts = {
      query: "cheese",
      match_type: "exact",
      link: "/lancashire-crumbly",
      position: 1,
      comment: "Boosting the best county's cheese to the top.",
      user_id: 1
    }
  end

  it "can be created given valid attributes" do
    best_bet = BestBet.new(@valid_atts)
    best_bet.save

    expect(best_bet).to be_valid
    expect(best_bet).to be_persisted
  end

  it "is invalid without a query" do
    best_bet = BestBet.new(@valid_atts.merge(query: ""))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:query)
  end

  it "is invalid without a link" do
    best_bet = BestBet.new(@valid_atts.merge(link: ""))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:link)
  end

  it "is valid without a comment" do
    best_bet = BestBet.new(@valid_atts.merge(comment: ""))

    expect(best_bet).to be_valid
  end

  it "is invalid with a match_type not in the predefined list" do
    best_bet = BestBet.new(@valid_atts.merge(match_type: "mature"))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:match_type)
  end

  it "is invalid with a blank match_type" do
    best_bet = BestBet.new(@valid_atts.merge(match_type: ""))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:match_type)
  end

  it "is invalid with a negative position" do
    best_bet = BestBet.new(@valid_atts.merge(position: -42))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:position)
  end

  it "is invalid with a non-integer position" do
    best_bet = BestBet.new(@valid_atts.merge(position: 3.141))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:position)
  end

  it "is valid with a nil position" do
    best_bet = BestBet.new(@valid_atts.merge(position: nil))

    expect(best_bet).to be_valid
  end

  it "is invalid without a user_id" do
    best_bet = BestBet.new(@valid_atts.merge(user_id: nil))

    expect(best_bet).to_not be_valid
    expect(best_bet.errors).to have_key(:user_id)
  end
end
