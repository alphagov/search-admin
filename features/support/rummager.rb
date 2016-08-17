Before do
  rummager_index_metasearch = double(:rummager_index_metasearch, add_document: nil, delete_document: nil)
  SearchAdmin.services(:rummager_index_metasearch, rummager_index_metasearch)

  rummager_index_mainstream = double(:rummager_index_mainstream, add_document: nil, delete_document: nil)
  SearchAdmin.services(:rummager_index_mainstream, rummager_index_mainstream)

  rummager_index_government = double(:rummager_index_government, add_document: nil, delete_document: nil)
  SearchAdmin.services(:rummager_index_government, rummager_index_government)
end
