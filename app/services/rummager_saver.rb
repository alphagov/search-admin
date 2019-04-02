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
      update_elasticsearch(query, :delete) if @object.is_a?(Query) && query.bets.any? # prevent old queries still being indexed in search
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
    if action != :delete && query.bets.any?
      es_doc = ElasticSearchBet.new(query)
      Services.rummager.add_document(es_doc.id, es_doc.body, 'metasearch')
    elsif action != :create # so hitting save with no best bets will delete the query
      es_doc_id = ElasticSearchBetIDGenerator.generate(query.query, query.match_type)
      Services.rummager.delete_document(URI.escape(es_doc_id), 'metasearch') # rubocop:disable Lint/UriEscapeUnescape
    end
  end

  def query
    @object.is_a?(Query) ? @object : @object.query
  end
end
