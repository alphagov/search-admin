RSpec.describe CompletionDenylistEntryImport do
  subject(:import) { described_class.new(category:, denylist_csv_data:) }
  let(:category) { "offensive" }

  describe "#save" do
    context "with tab-delimited input" do
      let(:denylist_csv_data) do
        [
          " foo\texact_match\tI don't like this word",
          "bar \tcontains\tI like this word even less",
          "baz\tCONTAINS\tDon't get me started on this one",
          "bat\tcontains", # 2 columns, no comment
          "bbb", # 1 column, no match type or comment
        ].join("\n")
      end

      it "persists the expected records" do
        expect { import.save }.to change { CompletionDenylistEntry.count }.by(5)

        expect(CompletionDenylistEntry.pluck(:phrase, :match_type, :category, :comment)).to contain_exactly(
          [" foo", "exact_match", "offensive", "I don't like this word"],
          ["bar ", "contains", "offensive", "I like this word even less"],
          ["baz", "contains", "offensive", "Don't get me started on this one"],
          ["bat", "contains", "offensive", nil],
          ["bbb", "exact_match", "offensive", nil],
        )
      end
    end

    context "with comma-delimited input" do
      let(:denylist_csv_data) do
        [
          " foo,exact_match,I don't like this word",
          "bar ,contains,I like this word even less",
          "baz,CONTAINS,Don't get me started on this one",
          "bat,contains", # 2 columns, no comment
          "bbb", # 1 column, no match type or comment
        ].join("\n")
      end

      it "persists the expected records" do
        expect { import.save }.to change { CompletionDenylistEntry.count }.by(5)

        expect(CompletionDenylistEntry.pluck(:phrase, :match_type, :category, :comment)).to contain_exactly(
          [" foo", "exact_match", "offensive", "I don't like this word"],
          ["bar ", "contains", "offensive", "I like this word even less"],
          ["baz", "contains", "offensive", "Don't get me started on this one"],
          ["bat", "contains", "offensive", nil],
          ["bbb", "exact_match", "offensive", nil],
        )
      end
    end

    context "with invalid raw input" do
      let(:denylist_csv_data) do
        [
          "foo,exact_match,I am the only valid record",
          " ,contains,I have no phrase",
          "bar,contains,I have an extra column,OMG",
        ].join("\n")
      end

      it "does not persist any records, even valid ones" do
        expect { import.save }.not_to(change { CompletionDenylistEntry.count })

        expect(import.errors.messages_for(:denylist_csv_data)).to contain_exactly(
          "contains invalid entry ' ,contains,I have no phrase' (does not contain a phrase)",
          "contains invalid entry 'bar,contains,I have an extra column,OMG' (has an unexpected number of columns)",
        )
      end
    end

    context "with valid raw input that fails CompletionDenylistEntry validation" do
      let!(:existing_entry) { create(:completion_denylist_entry, phrase: "baz") }
      let(:denylist_csv_data) do
        [
          "foo,exact_match,I am the only valid record",
          "bar,blub,Invalid match type",
          "baz,contains,Duplicate entry",
        ].join("\n")
      end

      it "does not persist any records, even valid ones" do
        expect { import.save }.not_to(change { CompletionDenylistEntry.count })

        expect(import.errors.count).to eq(2)
      end
    end

    context "with valid input that would take the total count over the limit" do
      let(:denylist_csv_data) do
        [
          "foo,exact_match",
          "bar,contains",
        ].join("\n")
      end

      before do
        # Assuming the limit is 1 for this test
        stub_const("CompletionDenylistEntry::MAX_ENTRIES", 1)
      end

      it "does not persist any records" do
        expect { import.save }.not_to(change { CompletionDenylistEntry.count })

        expect(import.errors.messages_for(:denylist_csv_data)).to contain_exactly(
          "would exceed the maximum number of entries (1)",
        )
      end
    end

    context "without any input" do
      let(:denylist_csv_data) { "\n\n  \n" }

      it "does not persist any records" do
        expect { import.save }.not_to(change { CompletionDenylistEntry.count })

        expect(import.errors).to be_of_kind(:denylist_csv_data, :blank)
      end
    end
  end
end
