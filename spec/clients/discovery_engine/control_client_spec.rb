RSpec.describe DiscoveryEngine::ControlClient, type: :client do
  let(:control) do
    instance_double(
      Control,
      to_upstream: { foo: "bar" },
      upstream_id: "search-admin-42",
      parent: "/parent",
      name: "/parent/search-admin-42",
    )
  end

  let(:discovery_engine_client) do
    double(
      Google::Cloud::DiscoveryEngine::V1::ControlService::Client,
      create_control: true,
      update_control: true,
      delete_control: true,
    )
  end

  before do
    allow(Google::Cloud::DiscoveryEngine)
      .to receive(:control_service).and_return(discovery_engine_client)
  end

  describe "#create" do
    it "creates the control on Discovery Engine" do
      expect(discovery_engine_client).to receive(:create_control).with(
        control: { foo: "bar" },
        control_id: "search-admin-42",
        parent: "/parent",
      )

      subject.create(control) # rubocop:disable Rails/SaveBang (not an ActiveRecord model)
    end
  end

  describe "#update" do
    it "updates the control on Discovery Engine" do
      expect(discovery_engine_client).to receive(:update_control).with(
        control: { foo: "bar" },
      )

      subject.update(control) # rubocop:disable Rails/SaveBang (not an ActiveRecord model)
    end
  end

  describe "#delete" do
    it "deletes the control on Discovery Engine" do
      expect(discovery_engine_client).to receive(:delete_control).with(
        name: "/parent/search-admin-42",
      )

      subject.delete(control)
    end
  end
end
