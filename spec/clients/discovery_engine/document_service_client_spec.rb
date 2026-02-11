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
      end

      it "deletes the document" do
        document_service_client.delete_document(content_id: content_id)

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
      end

      it "logs the failure" do
        document_service_client.delete_document(content_id: content_id)

        expect(Rails.logger)
          .to have_received(:info)
          .with("Did not delete document with content id #{content_id} as it doesn't exist remotely.")
      end

      it "does not send the error to Sentry" do
        document_service_client.delete_document(content_id: content_id)

        expect(GovukError).not_to have_received(:notify)
      end
    end
  end

  describe "#get_document" do
    context "when the get request succeeds" do
      let(:json_data) do
        {
          "url": "/some-url",
          "content_id": content_id.to_s,
          "title": "Document Title",
          "link": "/some-link",
        }.to_json
      end

      let(:retrieved_document) do
        double(
          {
            name: "document-name",
            id: content_id,
            schema_id: "default_schema",
            json_data: json_data,
            parent_document_id: "some_parent_document_id",
            content: {},
          },
        )
      end

      before do
        allow(discovery_engine_client).to receive(:get_document).and_return(retrieved_document)
      end

      it "retrieves the document" do
        document = document_service_client.get_document(content_id: content_id)

        expect(discovery_engine_client)
          .to have_received(:get_document)
          .with(name: "#{Branch.default.name}/documents/#{content_id}")

        assert_equal document, retrieved_document
      end
    end

    context "when the get request fails because the document doesn't exist" do
      let(:response) { Google::Cloud::NotFoundError }

      before do
        allow(discovery_engine_client).to receive(:get_document).and_raise(Google::Cloud::NotFoundError)
        allow(Rails.logger).to receive(:error)
        allow(GovukError).to receive(:notify)
      end

      it "raises an error" do
        expect { document_service_client.get_document(content_id: content_id) }.to raise_error(Google::Cloud::NotFoundError)

        expect(Rails.logger)
          .to have_received(:error)
                .with("Unable to retrieve document with content id #{content_id} as it doesn't exist remotely.")
      end
    end
  end
end
