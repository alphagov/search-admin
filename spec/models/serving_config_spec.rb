RSpec.describe ServingConfig, type: :model do
  it_behaves_like "RemoteSynchronizable", DiscoveryEngine::ServingConfigClient

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

  describe "#remote_resource_id" do
    subject(:serving_config) { create(:serving_config, remote_resource_id: "hello") }

    it "is immutable after initial creation" do
      expect { serving_config.update!(remote_resource_id: "goodbye") }.to raise_error(
        ActiveRecord::ReadonlyAttributeError,
      )
    end
  end

  describe "#preview_url" do
    subject(:serving_config) { create(:serving_config, remote_resource_id: "hello") }

    let(:finder_frontend_search) do
      instance_double(FinderFrontendSearch, url: "https://example.org")
    end

    before do
      allow(FinderFrontendSearch).to receive(:new)
        .with(keywords: "example search", debug_serving_config: "hello")
        .and_return(finder_frontend_search)
    end

    it "returns the preview URL" do
      expect(serving_config.preview_url).to eq("https://example.org")
    end
  end

  describe "#to_discovery_engine_serving_config" do
    subject(:serving_config) { create(:serving_config, controls:) }

    let(:boost_control) { build(:control, :with_boost_action) }
    let(:filter_control) { build(:control, :with_filter_action) }
    let(:controls) { [boost_control, filter_control] }

    it "returns a representation of the serving config for Discovery Engine" do
      expect(serving_config.to_discovery_engine_serving_config).to eq(
        {
          name: serving_config.name,
          boost_control_ids: [boost_control.remote_resource_id],
          filter_control_ids: [filter_control.remote_resource_id],
        },
      )
    end
  end
end
