RSpec.describe ServingConfig, type: :model do
  describe "default serving config" do
    subject!(:default_serving_config) { create(:serving_config, :default) }

    describe ".default" do
      it "returns the default serving config" do
        expect(described_class.default).to eq(default_serving_config)
      end
    end

    describe "#default?" do
      it { is_expected.to be_default }
    end

    describe "#destroy" do
      it "does not delete it" do
        expect { default_serving_config.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end
  end
end
