RSpec.describe DiscoveryEngine::ServingConfigClient do
  let(:serving_config) { build_stubbed(:serving_config) }

  let(:discovery_engine_client) do
    instance_double(
      Google::Cloud::DiscoveryEngine::V1::ServingConfigService::Client,
      update_serving_config: true,
    )
  end

  before do
    allow(Google::Cloud::DiscoveryEngine)
      .to receive(:serving_config_service).and_return(discovery_engine_client)
  end

  describe "#update" do
    it "updates the serving config on Discovery Engine" do
      expect(discovery_engine_client).to receive(:update_serving_config).with(
        serving_config: serving_config.to_discovery_engine_serving_config,
        update_mask: {
          paths: %i[boost_control_ids filter_control_ids],
        },
      )

      subject.update(serving_config) # rubocop:disable Rails/SaveBang (not an ActiveRecord model)
    end
  end
end
