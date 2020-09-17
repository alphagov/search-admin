class SearchApiSaver
  class InvalidAction < StandardError
    def initialize(message)
      super(message)
    end
  end
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

  def update(params)
    ActiveRecord::Base.transaction do
      update_elasticsearch(query_object, :delete) if is_query? && query_object.bets.any? # prevent old queries still being indexed in search
      @object.update!(params)
      update_elasticsearch(query_object, :update)
    end
    true
  rescue ActiveRecord::ActiveRecordError, GdsApi::HTTPInternalServerError, GdsApi::HTTPClientError
    false
  end

  def destroy(action:)
    ActiveRecord::Base.transaction do
      action == :deactivate ? @object.deactivate : @object.destroy!
      begin
        update_elasticsearch(query_object, action)
      rescue GdsApi::HTTPNotFound # rubocop:disable Lint/SuppressedException
      end
    end
    true
  rescue ActiveRecord::ActiveRecordError, GdsApi::HTTPInternalServerError, GdsApi::HTTPClientError
    false
  end

private

  def update_elasticsearch(query, action)
    if action == :create && query.bets.none? # prevents queries with no bets being indexed
      true
    elsif action == :delete || action == :update && query.bets.none? # removes queries with no bets from the index
      remove_from_elasticsearch
    elsif %i[update create].include?(action)
      add_to_elasticsearch
    elsif %i[update_bets deactivate].include?(action) # removing the final bet will de-index the query, removing any others will re-index
      query.bets.active.any? ? add_to_elasticsearch : remove_from_elasticsearch
    else
      raise InvalidAction, "#{action} not one of: :update, :create, :update_bets, : delete, :deactivate"
    end
  end

  def add_to_elasticsearch
    es_doc = ElasticSearchBet.new(query_object)
    Services.search_api.add_document(es_doc.id, es_doc.body, "metasearch")
  end

  def remove_from_elasticsearch
    es_doc_id = ElasticSearchBetIDGenerator.generate(query_object.query, query_object.match_type)
    Services.search_api.delete_document(URI.encode_www_form_component(es_doc_id).gsub("+", "%20"), "metasearch")
  end
end
