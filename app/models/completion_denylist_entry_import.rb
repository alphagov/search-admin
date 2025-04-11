# Parses and creates records for denylist entries from CSV-formatted input data, which can be either
# tab-separated (usually copy/pasted from Google Sheets) or comma-separated (from a CSV file or
# manual user input).
#
# At a minimum, each row must contain a phrase. It can also optionally contain a match type (assumed
# to be the default match type if empty) and a comment.
#
# The import is all-or-nothing: if any row in the input data or any of the records are invalid, the
# import will fail and no records will be created.
class CompletionDenylistEntryImport
  include ActiveModel::Model
  include ActiveModel::Validations
  extend ActiveModel::Translation

  attr_accessor :category, :denylist_csv_data

  validates :category, inclusion: { in: CompletionDenylistEntry.categories.keys }
  validates :denylist_csv_data, presence: true
  validate :sense_check_parsed_data, :validate_individual_records, :validate_total_count

  def save
    return false unless valid?

    # The records are valid at this point. This _would_ fail if several users were to ever try to
    # manage conflicting denylist entries at the same time, but that's so unlikely we'll just accept
    # that this could raise.
    records.each(&:save!)
    records
  end

  def records
    @records ||= parsed_data.map do |row|
      CompletionDenylistEntry.new(
        phrase: row[0],
        match_type: row[1]&.downcase || CompletionDenylistEntry.match_types.keys.first,
        comment: row[2].presence,
        category:,
      )
    end
  end

private

  def parsed_data
    @parsed_data ||= CSV.parse(denylist_csv_data, col_sep:).reject(&:blank?)
  end

  def col_sep
    # Assume that if the data contains a tab character (for example from being copied from Google
    # Sheets), it's tab-separated.
    return "\t" if denylist_csv_data.include?("\t")

    ","
  end

  def sense_check_parsed_data
    parsed_data.each do |row|
      unless row.size.in?(1..3)
        errors.add(:denylist_csv_data, :entry_invalid, phrase: row.join(","), reason: "has an unexpected number of columns")

        next
      end

      next if row[0].present?

      errors.add(:denylist_csv_data, :entry_invalid, phrase: row.join(","), reason: "does not contain a phrase")
    end
  end

  def validate_individual_records
    # Don't bother validating the records if the parsed data is already invalid
    return if errors.any?

    records.each do |record|
      next if record.valid?

      record.errors.full_messages.each do |reason|
        errors.add(:denylist_csv_data, :entry_invalid, phrase: record.phrase, reason:)
      end
    end
  end

  def validate_total_count
    return if CompletionDenylistEntry.count + records.size <= CompletionDenylistEntry::MAX_ENTRIES

    errors.add(
      :denylist_csv_data,
      :would_exceed_max_entries,
      count: CompletionDenylistEntry::MAX_ENTRIES,
    )
  end
end
