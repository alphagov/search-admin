RSpec.describe CompletionDenylistEntry, type: :model do
  subject(:completion_denylist_entry) { build(:completion_denylist_entry) }

  describe ".sync" do
    let(:client) { instance_double(DiscoveryEngine::CompletionDenylistClient) }
    let!(:completion_denylist_entry) { create(:completion_denylist_entry) }

    before do
      allow(DiscoveryEngine::CompletionDenylistClient).to receive(:new).and_return(client)
    end

    it "calls the client to sync entries" do
      expect(client).to receive(:import).with([completion_denylist_entry])
      expect(client).not_to receive(:purge)

      described_class.sync
    end

    it "calls the client to purge and sync entries when purge is specified" do
      expect(client).to receive(:purge)
      expect(client).to receive(:import).with([completion_denylist_entry])

      described_class.sync(purge: true)
    end
  end

  describe "normalizations" do
    context "for the phrase" do
      subject(:completion_denylist_entry) { build(:completion_denylist_entry, phrase: " TEA time") }

      it "normalizes the phrase" do
        completion_denylist_entry.save!
        # Note whitespace is intentionally not trimmed to allow for "phrase" matching
        expect(completion_denylist_entry.phrase).to eq(" tea time")
      end
    end
  end

  describe "validations" do
    it { is_expected.to be_valid }

    context "without a phrase" do
      before do
        completion_denylist_entry.phrase = nil
      end

      it "is not valid" do
        expect(completion_denylist_entry).not_to be_valid
        expect(completion_denylist_entry.errors).to be_of_kind(:phrase, :blank)
      end
    end

    context "with a phrase longer than 125 characters" do
      before do
        completion_denylist_entry.phrase = "a" * 126
      end

      it "is not valid" do
        expect(completion_denylist_entry).not_to be_valid
        expect(completion_denylist_entry.errors).to be_of_kind(:phrase, :too_long)
      end
    end

    context "with a duplicate phrase" do
      let!(:other_entry) { create(:completion_denylist_entry, phrase: "duplicate") }

      before do
        completion_denylist_entry.phrase = "duplicate"
      end

      it "is not valid" do
        expect(completion_denylist_entry).not_to be_valid
        expect(completion_denylist_entry.errors).to be_of_kind(:phrase, :taken)
      end
    end

    context "without a match_type" do
      before do
        completion_denylist_entry.match_type = nil
      end

      it "is not valid" do
        expect(completion_denylist_entry).not_to be_valid
        expect(completion_denylist_entry.errors).to be_of_kind(:match_type, :inclusion)
      end
    end

    context "with an invalid match_type" do
      before do
        completion_denylist_entry.match_type = "invalid"
      end

      it "is not valid" do
        expect(completion_denylist_entry).not_to be_valid
        expect(completion_denylist_entry.errors).to be_of_kind(:match_type, :inclusion)
      end
    end

    context "without a category" do
      before do
        completion_denylist_entry.category = nil
      end

      it "is not valid" do
        expect(completion_denylist_entry).not_to be_valid
        expect(completion_denylist_entry.errors).to be_of_kind(:category, :inclusion)
      end
    end

    context "with an invalid category" do
      before do
        completion_denylist_entry.category = "invalid"
      end

      it "is not valid" do
        expect(completion_denylist_entry).not_to be_valid
        expect(completion_denylist_entry.errors).to be_of_kind(:category, :inclusion)
      end
    end

    context "when the maximum number of entries has been exceeded" do
      let!(:existing_entry) { create(:completion_denylist_entry, phrase: "i'm all you need") }

      before do
        stub_const("CompletionDenylistEntry::MAX_ENTRIES", 1)
      end

      it "is not valid" do
        expect(completion_denylist_entry).not_to be_valid
        expect(completion_denylist_entry.errors).to be_of_kind(:base, :too_many_entries)
      end
    end
  end
end
