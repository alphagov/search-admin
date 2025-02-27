RSpec.describe DocumentExclusion, type: :model do
  describe "validations" do
    subject(:document_exclusion) { build(:document_exclusion) }

    it { is_expected.to be_valid }

    context "without a link" do
      before do
        document_exclusion.link = nil
      end

      it "is invalid" do
        expect(document_exclusion).to be_invalid
        expect(document_exclusion.errors).to be_of_kind(:link, :blank)
      end
    end

    context "with a duplicate link" do
      before do
        create(:document_exclusion, link: document_exclusion.link)
      end

      it "is invalid" do
        expect(document_exclusion).to be_invalid
        expect(document_exclusion.errors).to be_of_kind(:link, :taken)
      end
    end

    context "with an invalid link" do
      before do
        document_exclusion.link = "not a valid link"
      end

      it "is invalid" do
        expect(document_exclusion).to be_invalid
        expect(document_exclusion.errors).to be_of_kind(:link, :invalid)
      end
    end

    context "without a comment" do
      before do
        document_exclusion.comment = nil
      end

      it "is invalid" do
        expect(document_exclusion).to be_invalid
        expect(document_exclusion.errors).to be_of_kind(:comment, :blank)
      end
    end
  end

  describe "user assignment" do
    include_context "with a current user"

    subject(:document_exclusion) { described_class.create!(attributes) }
    let(:attributes) { attributes_for(:document_exclusion, user: nil) }

    it "assigns the current user" do
      expect(document_exclusion.user).to eq(current_user)
    end
  end
end
