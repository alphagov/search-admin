Before "@stub_best_bets" do
  @search_api = double(:search_api, delete_document: true, add_document: true)
  allow(Services).to receive(:search_api).and_return(@search_api)
end

Before "@stub_best_bets_with_404" do
  @search_api = double(:search_api, add_document: true)
  allow(@search_api).to receive(:delete_document).and_raise(GdsApi::HTTPNotFound.new(404))
  allow(Services).to receive(:search_api).and_return(@search_api)
end

Before "@stub_best_bets_with_500" do
  @search_api = double(:search_api)
  allow(@search_api).to receive(:delete_document).and_raise(GdsApi::HTTPClientError.new(500))
  allow(@search_api).to receive(:add_document).and_raise(GdsApi::HTTPClientError.new(500))
  allow(Services).to receive(:search_api).and_return(@search_api)
end
