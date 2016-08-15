Before do
  rummager_index_metasearch = double(:rummager_index_metasearch, add: nil, delete: nil)
  SearchAdmin.services(:rummager_index_metasearch, rummager_index_metasearch)

  rummager_index_mainstream = double(:rummager_index_mainstream, add: nil, delete: nil)
  SearchAdmin.services(:rummager_index_mainstream, rummager_index_mainstream)

  rummager_index_government = double(:rummager_index_government, add: nil, delete: nil)
  SearchAdmin.services(:rummager_index_government, rummager_index_government)
end
