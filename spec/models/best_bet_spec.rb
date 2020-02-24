require "spec_helper"

describe Bet do
  context "for a best bet" do
    let!(:recommended_link) { create(:recommended_link, link: external_link) }
    let(:external_bet_link) { external_link }
    let(:external_link) { "https://www.example.gov.uk/campaign" }

    before do
      @query = create(:query)
      @best_bet_attributes = {
        comment: "Boost the most common job page to the top",
        is_best: true,
        link: "/jobsearch",
        position: 1,
        query_id: @query.id,
        user_id: 1,
      }
    end

    it "can be created given valid attributes" do
      best_bet = Bet.new(@best_bet_attributes)
      best_bet.save

      expect(best_bet).to be_valid
      expect(best_bet).to be_persisted
    end

    it "is invalid without a query" do
      best_bet = Bet.new(@best_bet_attributes.merge(query_id: nil))

      expect(best_bet).to_not be_valid
      expect(best_bet.errors).to have_key(:query_id)
    end

    it "is invalid without a link" do
      best_bet = Bet.new(@best_bet_attributes.merge(link: ""))

      expect(best_bet).to_not be_valid
      expect(best_bet.errors).to have_key(:link)
    end

    context "when given a external link" do
      subject(:bet) { described_class.new(@best_bet_attributes.merge(link: external_bet_link)) }

      it { is_expected.to be_valid }

      context "when the external link has no corresponding recommended link" do
        let(:external_bet_link) { "https://invalid.example.org" }
        it { is_expected.to_not be_valid }
      end

      context "when the link doesn't start with http" do
        let(:external_bet_link) { "www.example.gov.uk/campaign" }
        it { is_expected.to_not be_valid }
      end

      context "when the link is an internal link" do
        let(:external_link) { "https://www.gov.uk/campaign" }
        it { is_expected.to_not be_valid }
      end
    end

    context "when given an internal link" do
      subject(:bet) { described_class.new(@best_bet_attributes.merge(link: internal_link)) }
      let(:internal_link) { "/harry-potter" }
      it { is_expected.to be_valid }

      context "when the internal link doesn't start with a forward slash" do
        let(:internal_link) { "harry-potter" }
        it { is_expected.to_not be_valid }
      end
    end

    it "is valid without a comment" do
      best_bet = Bet.new(@best_bet_attributes.merge(comment: ""))

      expect(best_bet).to be_valid
    end

    it "is invalid with a negative position" do
      best_bet = Bet.new(@best_bet_attributes.merge(position: -2))

      expect(best_bet).to_not be_valid
      expect(best_bet.errors).to have_key(:position)
    end

    it "is invalid with a non-integer position" do
      best_bet = Bet.new(@best_bet_attributes.merge(position: 3.5))

      expect(best_bet).to_not be_valid
      expect(best_bet.errors).to have_key(:position)
    end

    it "is invalid with a nil position" do
      best_bet = Bet.new(@best_bet_attributes.merge(position: nil))

      expect(best_bet).to_not be_valid
    end

    it "is invalid without a user_id" do
      best_bet = Bet.new(@best_bet_attributes.merge(user_id: nil))

      expect(best_bet).to_not be_valid
      expect(best_bet.errors).to have_key(:user_id)
    end

    describe "#is_query?" do
      it "should return false" do
        best_bet = Bet.new(@best_bet_attributes)

        expect(best_bet.is_query?).to eq false
      end
    end

    describe "#query_object" do
      it "should return its parent query" do
        best_bet = Bet.new(@best_bet_attributes)

        expect(best_bet.query_object).to eq @query
      end
    end
  end

  context "for a worst bet" do
    before do
      @worst_bet_attributes = {
        comment: "Mark as worst bet",
        is_best: false,
        link: "/jobsearch",
        position: nil,
        query_id: 1,
        user_id: 1,
      }
    end

    it "is valid with a nil position" do
      worst_bet = Bet.new(@worst_bet_attributes)

      expect(worst_bet).to be_valid
    end

    it "is valid with a position of 0" do
      worst_bet = Bet.new(@worst_bet_attributes.merge(position: 0))

      expect(worst_bet).to be_valid
    end
  end
end
