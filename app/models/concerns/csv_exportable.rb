# Allows generating a CSV report from a scope on a model.
#
# Use `csv_fields` to specify which attributes to include in the report after including the concern.
module CsvExportable
  extend ActiveSupport::Concern

  included do
    class_attribute :csv_exportable_attributes
    self.csv_exportable_attributes = []
  end

  class_methods do
    def to_csv
      CSV.generate(
        write_headers: true,
        headers: csv_headers,
      ) do |csv|
        find_each do |record|
          csv << record.attributes.values_at(*csv_exportable_attributes)
        end
      end
    end

  private

    def csv_fields(*attributes)
      self.csv_exportable_attributes += attributes.map(&:to_s)
    end

    def csv_headers
      csv_exportable_attributes.map { human_attribute_name(it) }
    end
  end
end
