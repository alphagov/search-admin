class RummagerSaver
  delegate :is_query?, :query_object, to: :@object

  def initialize(object)
    @object = object
  end

  def save
    ActiveRecord::Base.transaction do
      @object.save!
      update_elasticsearch(query_object, :create)
    end
    true
  rescue ActiveRecord::ActiveRecordError, GdsApi::HTTPInternalServerError, GdsApi::HTTPClientError
    false
  end

  def update_attributes(params)
    ActiveRecord::Base.transaction do
      update_elasticsearch(query_object, :delete) if is_query? && query_object.bets.any? # prevent old queries still being indexed in search
      @object.update_attributes!(params)
      update_elasticsearch(query_object, :update)
    end
    true
  rescue ActiveRecord::ActiveRecordError, GdsApi::HTTPInternalServerError, GdsApi::HTTPClientError
    false
  end

  def destroy(action: :delete)
    ActiveRecord::Base.transaction do
      @object.destroy!
      begin
        update_elasticsearch(query_object, action)
      rescue GdsApi::HTTPNotFound # rubocop:disable Lint/HandleExceptions
      end
    end
    true
  rescue ActiveRecord::ActiveRecordError, GdsApi::HTTPInternalServerError, GdsApi::HTTPClientError
    false
  end

private

  def update_elasticsearch(query, action)
    if %i[update create].include?(action) && query.bets.any? # prevents queries with no bets being indexed
      add_to_elasticsearch
    elsif action == :delete || action == :update && query.bets.none? # removes queries with no bets from the index
      remove_from_elasticsearch
    elsif action == :update_bets # removing the final bet will de-index the query, removing any others will re-index
      query.bets.any? ? add_to_elasticsearch : remove_from_elasticsearch
    end
  end

  def add_to_elasticsearch
    es_doc = ElasticSearchBet.new(query_object)
    Services.rummager.add_document(es_doc.id, es_doc.body, 'metasearch')
  end

  def remove_from_elasticsearch
    es_doc_id = ElasticSearchBetIDGenerator.generate(query_object.query, query_object.match_type)
    Services.rummager.delete_document(URI.escape(es_doc_id), 'metasearch') # rubocop:disable Lint/UriEscapeUnescape
  end
end
