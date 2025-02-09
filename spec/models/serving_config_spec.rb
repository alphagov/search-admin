RSpec.describe ServingConfig, type: :model do
  describe "validations" do
    subject(:serving_config) { build(:serving_config) }

    it { is_expected.to be_valid }

    context "without a display name" do
      before do
        serving_config.display_name = nil
      end

      it "is invalid" do
        expect(serving_config).to be_invalid
        expect(serving_config.errors).to be_of_kind(:display_name, :blank)
      end
    end

    context "without a remote resource ID" do
      before do
        serving_config.remote_resource_id = nil
      end

      it "is invalid" do
        expect(serving_config).to be_invalid
        expect(serving_config.errors).to be_of_kind(:remote_resource_id, :blank)
      end
    end

    context "with a duplicate remote resource ID" do
      before do
        create(:serving_config, remote_resource_id: "dupe")
        serving_config.remote_resource_id = "dupe"
      end

      it "is invalid" do
        expect(serving_config).to be_invalid
        expect(serving_config.errors).to be_of_kind(:remote_resource_id, :taken)
      end
    end
  end

  describe ".default" do
    subject(:default) { described_class.default }

    let!(:expected) { create(:serving_config, remote_resource_id: "govuk_default") }

    it { is_expected.to eq(expected) }
  end

  describe "#default?" do
    subject(:serving_config) { build(:serving_config, remote_resource_id:).default? }

    context "for the default serving config" do
      let(:remote_resource_id) { "govuk_default" }

      it { is_expected.to eq(true) }
    end

    context "for a non-default serving config" do
      let(:remote_resource_id) { "govuk_blah" }

      it { is_expected.to eq(false) }
    end
  end

  describe "#remote_resource_id" do
    subject(:serving_config) { create(:serving_config, remote_resource_id: "hello") }

    it "is immutable after initial creation" do
      expect { serving_config.update!(remote_resource_id: "goodbye") }.to raise_error(
        ActiveRecord::ReadonlyAttributeError,
      )
    end
  end
end
