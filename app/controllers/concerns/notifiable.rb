module Notifiable
  extend ActiveSupport::Concern

  def store_query_for_rummager(query, action)
    @attributes_to_send ||= []
    @attributes_to_send.push [query, action]
  end

  def send_change_notification
    queries_to_send = @attributes_to_send.reject(&:blank?)
    RummagerNotifier.notify(queries_to_send)
  end
end
