RSpec.describe Control, type: :model do
  let(:control) { build(:control) }

  describe "validations" do
    describe "boost_amount" do
      it "accepts valid values" do
        control.boost_amount = 0.5
        expect(control).to be_valid
      end

      it "refuses too low values" do
        control.boost_amount = -1.1
        expect(control).not_to be_valid
      end

      it "refuses too high values" do
        control.boost_amount = 1.1
        expect(control).not_to be_valid
      end
    end
  end
end
