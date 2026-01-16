RSpec.describe "document tasks" do
  describe "document:delete_document" do
    let(:document_service_client) { instance_double(DiscoveryEngine::DocumentServiceClient) }
    let(:discovery_engine_client) { instance_double(Google::Cloud::DiscoveryEngine::V1::DocumentService::Client) }
    let(:content_id) { "some-content-id" }

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
end
