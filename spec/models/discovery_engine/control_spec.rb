class FakeControllable
  include ActiveModel::Model

  attr_accessor :name

  def id
    42
  end

  def control_action
    { fake_action: { foo: "bar" } }
  end
end

RSpec.describe DiscoveryEngine::Control, type: :model do
  subject { described_class.new(controllable, client:) }

  let(:controllable) { FakeControllable.new(name: "A controllable") }
  let(:client) do
    double(
      Google::Cloud::DiscoveryEngine::V1::ControlService::Client,
      create_control: true,
      update_control: true,
      delete_control: true,
    )
  end

  describe "#id" do
    it "returns a unique ID based on the controllable's type and ID" do
      expect(subject.id).to eq("search-admin-fake_controllable-42")
    end
  end

  describe "#name" do
    it "returns the fully qualified name of the control based on the parent engine and ID" do
      expect(subject.name).to eq("[engine]/controls/search-admin-fake_controllable-42")
    end
  end

  describe "#create!" do
    it "creates the control on Discovery Engine" do
      expect(client).to receive(:create_control).with(
        control: {
          name: "[engine]/controls/search-admin-fake_controllable-42",
          display_name: "A controllable",
          fake_action: { foo: "bar" },
          solution_type: Google::Cloud::DiscoveryEngine::V1::SolutionType::SOLUTION_TYPE_SEARCH,
          use_cases: [Google::Cloud::DiscoveryEngine::V1::SearchUseCase::SEARCH_USE_CASE_SEARCH],
        },
        control_id: "search-admin-fake_controllable-42",
        parent: "[engine]",
      )

      subject.create!
    end

    context "when the creation fails" do
      before do
        allow(client).to receive(:create_control).and_raise(Google::Cloud::Error, "Uh oh")
      end

      it "raises an error" do
        expect { subject.create! }.to raise_error(DiscoveryEngine::Error, "Uh oh")
      end
    end
  end
  describe "#update!" do
    it "updates the control on Discovery Engine" do
      expect(client).to receive(:update_control).with(
        control: {
          name: "[engine]/controls/search-admin-fake_controllable-42",
          display_name: "A controllable",
          fake_action: { foo: "bar" },
          solution_type: Google::Cloud::DiscoveryEngine::V1::SolutionType::SOLUTION_TYPE_SEARCH,
          use_cases: [Google::Cloud::DiscoveryEngine::V1::SearchUseCase::SEARCH_USE_CASE_SEARCH],
        },
      )

      subject.update!
    end

    context "when the update fails" do
      before do
        allow(client).to receive(:update_control).and_raise(Google::Cloud::Error, "Uh oh")
      end

      it "raises an error" do
        expect { subject.update! }.to raise_error(DiscoveryEngine::Error, "Uh oh")
      end
    end
  end

  describe "#delete!" do
    it "deletes the control on Discovery Engine" do
      expect(client).to receive(:delete_control).with(name: "[engine]/controls/search-admin-fake_controllable-42")

      subject.delete!
    end

    context "when the deletion fails" do
      before do
        allow(client).to receive(:delete_control).and_raise(Google::Cloud::Error, "Uh oh")
      end

      it "raises an error" do
        expect { subject.delete! }.to raise_error(DiscoveryEngine::Error, "Uh oh")
      end
    end
  end
end
