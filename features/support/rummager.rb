Before do
  stub_any_rummager_delete(index: "mainstream")
  stub_any_rummager_delete(index: "metasearch")
  stub_any_rummager_post(index: "mainstream")
  stub_any_rummager_post(index: "metasearch")
end
