RSpec.describe DiscoveryEngine::ControlClient, type: :client do
  let(:control) do
    double(
      name: "control",
      remote_resource_id: "id",
      parent: Engine.default,
      to_discovery_engine_control: double,
    )
  end

  let(:discovery_engine_client) do
    instance_double(
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
        control: control.to_discovery_engine_control,
        control_id: "id",
        parent: Engine.default.name,
      )

      subject.create(control) # rubocop:disable Rails/SaveBang (not an ActiveRecord model)
    end
  end

  describe "#update" do
    it "updates the control on Discovery Engine" do
      expect(discovery_engine_client).to receive(:update_control).with(
        control: control.to_discovery_engine_control,
      )

      subject.update(control) # rubocop:disable Rails/SaveBang (not an ActiveRecord model)
    end
  end

  describe "#delete" do
    it "deletes the control on Discovery Engine" do
      expect(discovery_engine_client).to receive(:delete_control).with(
        name: control.name,
      )

      subject.delete(control)
    end
  end
end
