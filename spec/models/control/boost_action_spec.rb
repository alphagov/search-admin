RSpec.describe Control::BoostAction, type: :model do
  describe "validations" do
    subject(:action) { build(:control_boost_action) }

    it { is_expected.to be_valid }

    context "without a filter expression" do
      before do
        action.filter_expression = nil
      end

      it "is invalid" do
        expect(action).to be_invalid
        expect(action.errors).to be_of_kind(:filter_expression, :blank)
      end
    end

    context "without a boost factor" do
      before do
        action.boost_factor = nil
      end

      it "is invalid" do
        expect(action).to be_invalid
        expect(action.errors).to be_of_kind(:boost_factor, :not_a_number)
      end
    end

    context "with an out of range boost factor" do
      before do
        action.boost_factor = 1.1
      end

      it "is invalid" do
        expect(action).to be_invalid
        expect(action.errors).to be_of_kind(:boost_factor, :in)
      end
    end

    context "with a zero boost factor" do
      before do
        action.boost_factor = 0
      end

      it "is invalid" do
        expect(action).to be_invalid
        expect(action.errors).to be_of_kind(:boost_factor, :other_than)
      end
    end
  end

  describe "#to_discovery_engine_control_action" do
    subject(:boost) do
      build_stubbed(:control_boost_action, filter_expression: "foo = 1", boost_factor: 0.13)
    end

    it "returns a representation of the action for Discovery Engine" do
      expect(boost.to_discovery_engine_control_action).to eq({
        boost_action: {
          filter: "foo = 1",
          boost: 0.13,
          data_store: DataStore.default.name,
        },
      })
    end
  end
end
