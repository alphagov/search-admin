RSpec.describe "document tasks" do
  describe "document:delete_document" do
    let(:document_service_client) { instance_double(DiscoveryEngine::DocumentServiceClient) }
    let(:discovery_engine_client) { instance_double(Google::Cloud::DiscoveryEngine::V1::DocumentService::Client) }
    let(:content_id) { "some-content-id" }

    context "when a content id is passed in" do
      before do
        allow(DiscoveryEngine::DocumentServiceClient).to receive(:new).and_return(document_service_client)
        allow(DiscoveryEngine::Services).to receive(:document_service).and_return(discovery_engine_client)
        allow(discovery_engine_client).to receive(:delete_document).and_return(Google::Protobuf::Empty)
        Rake::Task["document:delete_document"].reenable
      end

      it "calls the DocumentServiceClient" do
        expect(document_service_client)
          .to receive(:delete_document)
          .with(content_id: content_id)

        Rake::Task["document:delete_document"].invoke(content_id)
      end
    end

    context "when no content id is passed in" do
      before do
        Rake::Task["document:delete_document"].reenable
      end

      it "raises an Argument error" do
        expect { Rake::Task["document:delete_document"].invoke }
          .to raise_error(ArgumentError, "Content ID is required")
      end
    end
  end
end
