class ElasticSearchMltResult
  include ActiveModel::Model

  VALID_FIELDS = %w(
    title
    link
    format
    es_score
    content_store_document_type
  ).freeze

  attr_accessor(*VALID_FIELDS.map(&:to_sym))
end
