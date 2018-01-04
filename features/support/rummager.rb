Before "@stub_best_bets" do
  @rummager = double(:rummager, delete_document: true, add_document: true)
  allow(Services).to receive(:rummager).and_return(@rummager)
end

Before "@stub_best_bets_with_404" do
  @rummager = double(:rummager, add_document: true)
  allow(@rummager).to receive(:delete_document).and_raise(GdsApi::HTTPNotFound.new(404))
  allow(Services).to receive(:rummager).and_return(@rummager)
end

Before "@stub_best_bets_with_500" do
  @rummager = double(:rummager)
  allow(@rummager).to receive(:delete_document).and_raise(GdsApi::HTTPClientError.new(500))
  allow(@rummager).to receive(:add_document).and_raise(GdsApi::HTTPClientError.new(500))
  allow(Services).to receive(:rummager).and_return(@rummager)
end
