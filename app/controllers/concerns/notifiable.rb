module Notifiable
  extend ActiveSupport::Concern

  def store_query_for_rummager(query)
    @attributes_to_send ||= []
    @attributes_to_send.push [query.query, query.match_type]
  end

  def send_change_notification
    attributes_to_send = @attributes_to_send.reject { |set| set.blank? }
    RummagerNotifier.notify(attributes_to_send)
  end
end
