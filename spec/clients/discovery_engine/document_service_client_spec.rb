RSpec.describe DiscoveryEngine::DocumentServiceClient, type: :client do
  subject(:document_service_client) { described_class.new }
  let(:discovery_engine_client) { instance_double(Google::Cloud::DiscoveryEngine::V1::DocumentService::Client) }
  let(:content_id) { "some-content-id" }

  before do
    allow(DiscoveryEngine::Services).to receive(:document_service).and_return(discovery_engine_client)
  end

  describe "#delete_document" do
    context "when the delete succeeds" do
      before do
        allow(discovery_engine_client).to receive(:delete_document).and_return(Google::Protobuf::Empty)
        document_service_client.delete_document(content_id: content_id)
      end

      it "deletes the document" do
        expect(discovery_engine_client)
          .to have_received(:delete_document)
          .with(name: "#{Branch.default.name}/documents/#{content_id}")
      end
    end

    context "when the delete fails because the document doesn't exist" do
      let(:response) { Google::Cloud::NotFoundError }
      before do
        allow(discovery_engine_client).to receive(:delete_document).and_raise(Google::Cloud::NotFoundError)
        allow(Rails.logger).to receive(:info)
        allow(GovukError).to receive(:notify)
        document_service_client.delete_document(content_id: content_id)
      end

      it "logs the failure" do
        expect(Rails.logger)
          .to have_received(:info)
          .with("Did not delete document with content id #{content_id} as it doesn't exist remotely.")
      end

      it "does not send the error to Sentry" do
        expect(GovukError).not_to have_received(:notify)
      end
    end
  end
end
