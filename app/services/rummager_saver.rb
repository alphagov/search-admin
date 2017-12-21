class RummagerSaver
  def initialize(object)
    @object = object
  end

  def save
    ActiveRecord::Base.transaction do
      @object.save!
      update_elasticsearch(query, :create)
    end
    true
  rescue ActiveRecord::ActiveRecordError, GdsApi::HTTPInternalServerError, GdsApi::HTTPClientError
    false
  end

  def update_attributes(params)
    ActiveRecord::Base.transaction do
      @object.update_attributes!(params)
      update_elasticsearch(query, :update)
    end
    true
  rescue ActiveRecord::ActiveRecordError, GdsApi::HTTPInternalServerError, GdsApi::HTTPClientError
    false
  end

  def destroy(action: :delete)
    ActiveRecord::Base.transaction do
      @object.destroy!
      begin
        update_elasticsearch(query, action)
      rescue GdsApi::HTTPNotFound # rubocop:disable Lint/HandleExceptions
      end
    end
    true
  rescue ActiveRecord::ActiveRecordError, GdsApi::HTTPInternalServerError, GdsApi::HTTPClientError
    false
  end

private

  def update_elasticsearch(query, action)
    if action == :delete || (action == :update_bets && query.bets.empty?)
      es_doc_id = ElasticSearchBetIDGenerator.generate(query.query, query.match_type)
      Services.rummager.delete_document(CGI.escape(es_doc_id))
    elsif query.bets.any? # don't create ES entry until query has some bets
      es_doc = ElasticSearchBet.new(query)
      Services.rummager.add_document(es_doc.id, es_doc.body, 'metasearch')
    end
  end

  def query
    @object.respond_to?(:query) ? @object.query : @object
  end
end
