RSpec.describe Engine do
  subject(:engine) { described_class.new("my-engine") }

  describe ".default" do
    it "returns the default engine" do
      expect(described_class.default).to eq(described_class.new("govuk"))
    end
  end

  describe "#name" do
    it "returns the fully qualified name of the engine" do
      expect(subject.name).to eq("[collection]/engines/my-engine")
    end
  end
end
