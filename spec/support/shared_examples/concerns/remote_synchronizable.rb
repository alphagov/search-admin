RSpec.shared_examples "RemoteSynchronizable" do |client_class|
  let(:client) do
    instance_double(client_class, create: true, update: true, delete: true)
  end
  let(:factory) { described_class.model_name.param_key }

  before do
    allow(client_class).to receive(:new).and_return(client)
  end

  describe "#save_and_sync" do
    describe "when creating a new record" do
      subject(:record) { build(factory) }

      it "creates the remote resource using the client" do
        record.save_and_sync

        expect(client).to have_received(:create).with(record)
      end

      it "persists the record before passing it to the client" do
        expect(client).to receive(:create).with(an_object_satisfying(&:persisted?))

        record.save_and_sync
      end

      context "when the remote resource creation fails" do
        let(:error) { RuntimeError.new("Uh oh") }

        before do
          allow(client).to receive(:create).and_raise(error)

          record.save_and_sync
        end

        it "stops the record from being created" do
          expect(record).not_to be_persisted
        end

        it "adds an error to the record" do
          expect(record.errors).to be_of_kind(:base, :remote_error)
        end
      end
    end

    describe "when updating an existing record" do
      subject(:record) { create(factory) }

      it "updates the remote resource" do
        record.save_and_sync

        expect(client).to have_received(:update).with(record)
      end

      context "when the remote resource update fails" do
        let(:error) { ClientError.new("Uh oh") }

        before do
          allow(client).to receive(:update).and_raise(error)

          record.updated_at = Time.current # change something so we can check it won't save
          record.save_and_sync
        end

        it "stops the record from being persisted" do
          expect(record).to be_changed
        end

        it "adds an error to the record" do
          expect(record.errors).to be_of_kind(:base, :remote_error)
        end
      end
    end
  end

  describe "when destroying an existing record" do
    subject(:record) { create(factory) }

    it "deletes the remote resource" do
      record.destroy_and_sync

      expect(client).to have_received(:delete).with(record)
    end

    context "when the remote resource deletion fails with an internal error" do
      let(:error) { ClientError.new("Uh oh") }

      before do
        allow(client).to receive(:delete).and_raise(error)

        record.destroy_and_sync
      end

      it "stops the record from being destroyed" do
        expect(described_class.exists?(record.id)).to be(true)
      end

      it "adds an error to the record" do
        expect(record.errors).to be_of_kind(:base, :remote_error)
      end
    end
  end
end
