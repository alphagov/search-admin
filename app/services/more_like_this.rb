class MoreLikeThis
  class Error < StandardError; end
  class NotFoundInSearch < Error; end
  class NotTaggedToATaxon < Error; end
  class NoSearchResults < Error; end

  attr_reader :base_path

  def initialize(base_path)
    @base_path = base_path
  end

  def self.from_base_path(base_path)
    new(base_path).from_base_path
  end

  def from_base_path
    raise NotFoundInSearch if content_item.nil?
    raise NotTaggedToATaxon if tagged_taxon_content_id.nil?
    raise NoSearchResults if search_results.empty?

    search_results.reduce([]) do |mlt_results, search_result|
      mlt_results << ElasticSearchMltResult.new(
        search_result.slice(*ElasticSearchMltResult::VALID_FIELDS)
      )
    end
  end

private

  def tagged_taxon_content_id
    taxon_content_ids = content_item['taxons'] || []
    return if taxon_content_ids.empty?

    # TODO: handle multiple tagged taxons in results
    taxon_content_ids.first
  end

  def search_results
    Services.rummager.search(
      similar_to: base_path,
      start: 0,
      count: 25,
      filter_taxons: [tagged_taxon_content_id],
      fields: %w(title link format content_store_document_type)
    )['results']
  end

  def content_item
    Services.rummager.search(
      filter_link: base_path,
      fields: %w(taxons)
    )['results'].first
  end
end
