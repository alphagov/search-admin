RSpec.describe RecommendedLink do
  describe "#content_id" do
    subject(:recommended_link) { build(:recommended_link) }

    it "is generated on initial create" do
      expect { recommended_link.save }.to change { recommended_link.content_id }.from(nil)
    end
  end

  describe "validations" do
    subject(:recommended_link) { build(:recommended_link, link:) }

    context "with an incomplete link" do
      let(:link) { "www.hello-world.com" }

      it "is invalid" do
        expect(recommended_link).not_to be_valid
        expect(recommended_link.errors.full_messages).to eq(["Link is an invalid URL"])
      end
    end

    context "with a link without a host" do
      let(:link) { "http:/path-not-host" }

      it "is invalid" do
        expect(recommended_link).not_to be_valid
        expect(recommended_link.errors.full_messages).to eq(["Link does not have a valid host"])
      end
    end

    context "with a duplicate link" do
      let(:link) { "https://www.tax.service.gov.uk/" }

      before do
        create(:recommended_link, link: link)
      end

      it "is invalid" do
        expect(recommended_link).not_to be_valid
        expect(recommended_link.errors.full_messages).to eq(["Link has already been taken"])
      end
    end
  end
end
