desc "Tasks related to Discovery Engine's document service"
namespace :document do
  # Documents are usually deleted by sending an unpublish message from Publishing API.
  # This rake task should only be used in dire emergencies where content isn’t correctly
  # deleted through the normal channels. This can happen when someone deletes a document
  # directly from the Publishing API database without firing the callbacks that trigger
  # a message queue unpublish message.
  desc "Delete a specific document from Google Vertex Datastore"
  task :delete_document, [:content_id] => :environment do |_, args|
    raise ArgumentError, "Content ID is required" if args[:content_id].nil?

    DiscoveryEngine::DocumentServiceClient.new.delete_document(content_id: args[:content_id])
  end

  desc "Get a specific document from Google Vertex Datastore"
  task :get_document, [:content_id] => :environment do |_, args|
    raise ArgumentError, "Content ID is required" if args[:content_id].nil?

    document = DiscoveryEngine::DocumentServiceClient.new.get_document(content_id: args[:content_id])
    pp JSON.parse(document.json_data) if document.present?
  end
end
