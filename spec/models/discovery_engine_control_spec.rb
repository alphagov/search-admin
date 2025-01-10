RSpec.describe DiscoveryEngineControl, type: :model do
  describe "validations" do
    subject(:control) { described_class.new }

    it "does not allow an invalid boost amount" do
      control.action = :boost
      control.boost_amount = 1.1

      expect(control).not_to be_valid
      expect(control.errors[:boost_amount]).not_to be_empty
    end

    it "does not allow a boost amount for non-boost actions" do
      control.action = :filter
      control.boost_amount = 0.5

      expect(control).not_to be_valid
      expect(control.errors[:boost_amount]).not_to be_empty
    end
  end
end
