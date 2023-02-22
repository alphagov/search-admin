require "spec_helper"
require "travel_advice_bets_importer"

RSpec.describe TravelAdviceBetsImporter do
  let(:csv_data) do
    [
      ["Angola", "/world/angola"],
      ["Belgium", "/world/belgium"],
      ["Spain", "/world/spain"],
    ]
  end
  let(:logger) { double(:logger) }
  let(:search_api_saver) { double(:search_api_saver) }
  let(:user) { create(:user) }

  subject(:instance) { described_class.new(csv_data, user, logger) }

  describe "import" do
    before do
      allow(SearchApiSaver).to receive(:new)
        .and_return(search_api_saver)
      allow(search_api_saver).to receive(:save)
        .and_return(true)
      allow(logger).to receive(:puts)
    end

    it "creates queries" do
      expect { instance.import }.to change(Query, :count).by(3)
    end

    it "creates bets" do
      expect { instance.import }.to change(Bet, :count).by(6)
      expect(Bet.all.map(&:link)).to eq([
        "/foreign-travel-advice/angola",
        "/world/angola",
        "/foreign-travel-advice/belgium",
        "/world/belgium",
        "/foreign-travel-advice/spain",
        "/world/spain",
      ])
    end

    it "saves bets in Search-api" do
      instance.import
      expect(search_api_saver).to have_received(:save).exactly(6).times
      expect(SearchApiSaver).to have_received(:new).with(Bet.first)
      expect(SearchApiSaver).to have_received(:new).with(Bet.last)
    end

    it "logs stuff" do
      instance.import
      expect(logger).to have_received(:puts)
        .with("Saved best bet 'Spain': '/foreign-travel-advice/spain' (pos: 1) to Search-api.")
      expect(logger).to have_received(:puts)
        .with("Saved best bet 'Spain': '/world/spain' (pos: 2) to Search-api.")
    end

    it "increments an internal count of successful saves" do
      instance.import
      expect(instance.count).to eq(6)
    end

    context "with valid and invalid data" do
      before do
        csv_data.push(%w[Narnia narnia])
      end

      it "skips invalid data" do
        expect(Query.find_by(query: "Narnia")).to be_nil
        expect(Bet.find_by(link: "narnia")).to be_nil
      end
    end

    context "with existing, conflicting bets" do
      let(:query) { create(:query, query: "Spain") }
      let!(:bet) { create(:bet, :permanent, link: "/world/spain", query:, position: 2) }

      it "doesn't create duplicates" do
        expect { instance.import }.to change(Bet, :count).by(5)
        expect(Bet.where(link: "/world/spain").count).to eq(1)
      end

      it "doesn't save duplicates in Search-api" do
        instance.import
        expect(search_api_saver).to have_received(:save).exactly(5).times
        expect(instance.count).to eq(5)
      end
    end

    context "with existing non-conflicting bets" do
      let(:query) { create(:query, query: "Spain") }
      let!(:bet) { create(:bet, :permanent, link: "/world/spain", query:, position: 2) }
      before { csv_data.push(%w[Espana /world/spain]) }

      it "creates a best bet" do
        instance.import
        expect(Query.where(query: "Spain").count).to eq(1)
        expect(Query.where(query: "Espana").count).to eq(1)
        expect(Bet.where(link: "/world/spain").count).to eq(2)
      end
    end
  end
end
