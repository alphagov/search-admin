RSpec.describe CompletionDenylistEntry, type: :model do
  subject(:completion_denylist_entry) { build(:completion_denylist_entry) }

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

  describe "#to_discovery_engine_completion_denylist_entry" do
    subject(:completion_denylist_entry) do
      build(:completion_denylist_entry, phrase: "oh, block it all out", match_type: :exact_match)
    end

    it "returns the completion denylist entry as a hash with the expected format" do
      expect(completion_denylist_entry.to_discovery_engine_completion_denylist_entry).to eq(
        block_phrase: "oh, block it all out",
        match_operator: "EXACT_MATCH",
      )
    end
  end
end
