RSpec.describe DiscoveryEngine::ControlClient, type: :client do
  let(:control) { build(:control, id: 42) }

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
        control_id: "search-admin-42",
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

    context "when the operation raises an arbitrary error" do
      before do
        allow(discovery_engine_client).to receive(:update_control).and_raise(Google::Cloud::Error)
      end

      it "raises a ClientInternalError and adds a base validation error" do
        expect { subject.update(control) }.to raise_error(ClientError)

        expect(control.errors).to be_of_kind(:base, :remote_error)
      end
    end

    context "when the operation raises an invalid argument error about filter expressions" do
      before do
        allow(discovery_engine_client)
          .to receive(:update_control)
          .and_raise(Google::Cloud::InvalidArgumentError, "The filter syntax is broken")
      end

      it "raises a ClientInternalError and adds a field validation error on action" do
        expect { subject.update(control) }.to raise_error(ClientError)

        expect(control.action.errors).to be_of_kind(:filter_expression, :invalid)
      end
    end

    context "when the operation raises an invalid argument error about anything else" do
      before do
        allow(discovery_engine_client)
          .to receive(:update_control)
          .and_raise(Google::Cloud::InvalidArgumentError, "The splines are unreticulated")
      end

      it "raises a ClientInternalError and adds a base validation error" do
        expect { subject.update(control) }.to raise_error(ClientError)

        expect(control.errors).to be_of_kind(:base, :remote_error)
      end
    end
  end

  describe "#delete" do
    it "deletes the control on Discovery Engine" do
      expect(discovery_engine_client).to receive(:delete_control).with(
        name: control.name,
      )

      subject.delete(control)
    end

    context "when the operation raises an arbitrary error" do
      before do
        allow(discovery_engine_client).to receive(:delete_control).and_raise(Google::Cloud::Error)
      end

      it "raises a ClientInternalError and adds a base validation error" do
        expect { subject.delete(control) }.to raise_error(ClientError)

        expect(control.errors).to be_of_kind(:base, :remote_error)
      end
    end
  end
end
