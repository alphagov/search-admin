RSpec.describe Boost, type: :model do
  let(:boost) { build(:boost) }

  describe "validations" do
    describe "name" do
      it "accepts valid values" do
        boost.name = "Test"

        expect(boost).to be_valid
      end

      it "refuses empty values" do
        boost.name = ""

        expect(boost).not_to be_valid
        expect(boost.errors[:name]).not_to be_empty
      end
    end

    describe "filter" do
      it "accepts valid values" do
        boost.filter = "something"

        expect(boost).to be_valid
      end

      it "refuses empty values" do
        boost.filter = ""

        expect(boost).not_to be_valid
        expect(boost.errors[:filter]).not_to be_empty
      end
    end

    describe "boost_amount" do
      it "accepts valid values" do
        boost.boost_amount = 0.5

        expect(boost).to be_valid
      end

      it "refuses too low values" do
        boost.boost_amount = -1.1

        expect(boost).not_to be_valid
        expect(boost.errors[:boost_amount]).not_to be_empty
      end

      it "refuses too high values" do
        boost.boost_amount = 1.1

        expect(boost).not_to be_valid
        expect(boost.errors[:boost_amount]).not_to be_empty
      end

      it "refuses empty values" do
        boost.boost_amount = nil

        expect(boost).not_to be_valid
        expect(boost.errors[:boost_amount]).not_to be_empty
      end
    end
  end
end
