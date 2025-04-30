class CompletionDenylistEntry < ApplicationRecord
  # The maximum length of the phrase (API limit)
  MAX_PHRASE_LENGTH = 125
  # The maximum number of denylist entries permitted at any one time (API limit)
  MAX_ENTRIES = 1000

  enum :category, {
    general: 0,
    names: 1,
    offensive: 2,
  }, validate: true

  enum :match_type, {
    # see https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1/latest/Google-Cloud-DiscoveryEngine-V1-SuggestionDenyListEntry-MatchOperator
    exact_match: 0,
    contains: 1,
  }, validate: true

  validates :phrase, presence: true, length: { maximum: MAX_PHRASE_LENGTH }, uniqueness: true
  normalizes :phrase, with: ->(phrase) { phrase.downcase }
  validate :does_not_exceed_maximum_entries

  def to_discovery_engine_completion_denylist_entry
    {
      block_phrase: phrase,
      match_operator: match_type.upcase,
    }
  end

private

  def does_not_exceed_maximum_entries
    return if CompletionDenylistEntry.count < MAX_ENTRIES

    errors.add(:base, :too_many_entries, max_entries: MAX_ENTRIES)
  end
end
