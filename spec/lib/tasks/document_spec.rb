RSpec.describe "document tasks" do
  let(:document_service_client) { instance_double(DiscoveryEngine::DocumentServiceClient) }
  let(:discovery_engine_client) { instance_double(Google::Cloud::DiscoveryEngine::V1::DocumentService::Client) }
  let(:content_id) { "some-content-id" }

  before do
    Rake::Task[task_name].reenable
    allow(DiscoveryEngine::DocumentServiceClient).to receive(:new).and_return(document_service_client)
    allow(DiscoveryEngine::Services).to receive(:document_service).and_return(discovery_engine_client)
  end

  describe "document:delete_document" do
    let(:task_name) { "document:delete_document" }

    context "when a content id is passed in" do
      before do
        allow(discovery_engine_client).to receive(:delete_document).and_return(Google::Protobuf::Empty)
      end

      it "calls the DocumentServiceClient" do
        expect(document_service_client)
          .to receive(:delete_document)
          .with(content_id: content_id)

        Rake::Task[task_name].invoke(content_id)
      end
    end

    context "when no content id is passed in" do
      it "raises an Argument error" do
        expect { Rake::Task[task_name].invoke }
          .to raise_error(ArgumentError, "Content ID is required")
      end
    end
  end

  describe "document:get_document" do
    let(:task_name) { "document:get_document" }

    context "when a content id is passed in" do
      it "calls the DocumentServiceClient" do
        expect(document_service_client)
          .to receive(:get_document)
                .with(content_id: content_id)

        Rake::Task[task_name].invoke(content_id)
      end

      context "when the document is found" do
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
          allow(document_service_client).to receive(:get_document).and_return(retrieved_document)
        end

        it "logs the json_data for the document" do
          output = capture_stdout { Rake::Task[task_name].invoke(content_id) }

          # check document includes expected key/value pairs
          expect(output).to include('"content_id" => "some-content-id"')
          expect(output).to include('"link" => "/some-link"')
          expect(output).to include('"title" => "Document Title"')
          expect(output).to include('"url" => "/some-url"')

          # check output is multi-line (pretty-printed)
          expect(output).to include("\n")
          expect(output.lines.count).to be > 1
        end
      end

      context "when the document is not found" do
        before do
          allow(document_service_client).to receive(:get_document).and_raise(Google::Cloud::NotFoundError)
        end

        it "raises an error" do
          expect { Rake::Task[task_name].invoke(content_id) }.to raise_error(Google::Cloud::NotFoundError)
        end
      end
    end

    context "when no content id is passed in" do
      it "raises an Argument error" do
        expect { Rake::Task[task_name].invoke }
          .to raise_error(ArgumentError, "Content ID is required")
      end
    end
  end
end
