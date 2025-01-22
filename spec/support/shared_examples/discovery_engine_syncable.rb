RSpec.shared_examples "Discovery Engine syncable" do |resource_class|
  let(:resource) do
    instance_double(resource_class, create!: true, update!: true, delete!: true)
  end

  before do
    allow(resource_class).to receive(:new).with(record).and_return(resource)
  end

  describe "#save_and_sync for a new record" do
    subject(:record) { described_class.new(attributes) }

    it "creates the resource" do
      record.save_and_sync

      expect(resource).to have_received(:create!)
    end

    it "persists the record" do
      record.save_and_sync

      expect(record).to be_persisted
    end

    context "when the resource creation fails" do
      let(:error) { DiscoveryEngine::Error.new("Uh oh") }

      before do
        allow(resource).to receive(:create!).and_raise(error)
      end

      it "does not persist the record" do
        record.save_and_sync

        expect(record).not_to be_persisted
      end

      it "adds an error to the record" do
        record.save_and_sync

        expect(record.errors).to be_of_kind(:base, :discovery_engine_unrecoverable)
      end
    end
  end

  describe "#save_and_sync for an existing record" do
    subject(:record) { described_class.create!(attributes) }

    before do
      record.name = "New name"
    end

    it "updates the resource" do
      expect(resource).to receive(:update!)

      record.save_and_sync
    end

    context "when the resource update fails" do
      let(:error) { DiscoveryEngine::Error.new("Uh oh") }

      before do
        allow(resource).to receive(:update!).and_raise(error)
      end

      it "does not persist the changes to the record" do
        record.save_and_sync

        expect(record).to be_changed
      end

      it "adds an error to the record" do
        record.save_and_sync

        expect(record.errors).to be_of_kind(:base, :discovery_engine_unrecoverable)
      end
    end
  end

  describe "#destroy_and_sync" do
    subject(:record) { described_class.create!(attributes) }

    it "deletes the resource" do
      record.destroy_and_sync

      expect(resource).to have_received(:delete!)
    end

    it "destroys the record" do
      record.destroy_and_sync

      expect(record).to be_destroyed
    end

    context "when the resource deletion fails" do
      let(:error) { DiscoveryEngine::Error.new("Uh oh") }

      before do
        allow(resource).to receive(:delete!).and_raise(error)
      end

      it "does not destroy the record" do
        record.destroy_and_sync

        expect(record).to be_persisted
      end

      it "adds an error to the record" do
        record.destroy_and_sync

        expect(record.errors).to be_of_kind(:base, :discovery_engine_unrecoverable)
      end
    end
  end
end
