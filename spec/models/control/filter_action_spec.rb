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
end
