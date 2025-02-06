RSpec.describe Control::FilterAction, type: :model do
  describe "validations" do
    subject(:action) { build(:control_filter_action) }

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
  end

  describe "#to_discovery_engine_control_action" do
    subject(:filter) { build_stubbed(:control_filter_action, filter_expression: "foo = 1") }

    it "returns a representation of the action for Discovery Engine" do
      expect(filter.to_discovery_engine_control_action).to eq({
        filter_action: {
          filter: "foo = 1",
          data_store: DataStore.default.name,
        },
      })
    end
  end
end
