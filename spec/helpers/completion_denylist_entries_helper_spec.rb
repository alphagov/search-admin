RSpec.describe CompletionDenylistEntriesHelper do
  describe "#completion_denylist_entry_phrase_with_visible_spaces" do
    subject { helper.completion_denylist_entry_phrase_with_visible_spaces(completion_denylist_entry) }

    let(:completion_denylist_entry) { build(:completion_denylist_entry, phrase: "evil phrase") }

    it { is_expected.to eq("evil<span class=\"app-denylist-entry-visible-space\"> </span>phrase") }
  end
end
