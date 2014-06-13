class AttributeStore
  attr_reader :previous_attributes, :updated_attributes

  def initialize
    @previous_attributes = []
    @updated_attributes = []
    @response = []
  end

  def add_previous_attributes_for(query)
    @previous_attributes.push query.query, query.match_type
  end

  def add_updated_attributes_for(query)
    @updated_attributes.push query.query, query.match_type
  end

  def attributes
    generate_attributes
  end

private

  attr_reader :response

  def generate_attributes
    response.push @updated_attributes
    response.push @previous_attributes
    response.reject { |set| set.blank? }
  end
end
