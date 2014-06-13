class BetChangeNotifier
  attr_reader :attributes, :notification_service

  def initialize(notification_service, attributes)
    @notification_service = notification_service
    @attributes = attributes
  end

  def notify
    notify_service
  end

private

  def notify_service
    notification_service.notify(:bet_changed, attributes)
  end
end
