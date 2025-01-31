RSpec.describe Control, type: :model do
  describe "validations" do
    subject(:control) { build(:control) }

    it { is_expected.to be_valid }

    context "without a display name" do
      before do
        control.display_name = nil
      end

      it "is invalid" do
        expect(control).to be_invalid
        expect(control.errors).to be_of_kind(:display_name, :blank)
      end
    end

    context "without an action" do
      before do
        control.action = nil
      end

      it "is invalid" do
        expect(control).to be_invalid
        expect(control.errors).to be_of_kind(:action, :blank)
      end
    end
  end
end
