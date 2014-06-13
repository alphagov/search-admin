module Notifiable
  extend ActiveSupport::Concern

  def store_previous_attributes_for(query)
    attribute_store.add_previous_attributes_for(query)
  end

  def store_updated_attributes_for(query)
    attribute_store.add_updated_attributes_for(query)
  end

  def send_change_notification
    notification_service.notify
  end

  def attribute_store
    @_attribute_store ||= AttributeStore.new
  end

  def notification_service
    BetChangeNotifier.new(
      SearchAdmin.services(:message_bus),
      attribute_store.attributes
    )
  end
end
