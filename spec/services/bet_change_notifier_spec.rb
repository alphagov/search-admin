require 'spec_helper'

describe BetChangeNotifier, '#notify' do
  it 'notifies the passed in service of the changes to a bet' do
    notification_service = double('notification_service')
    attributes = double('attributes')

    expect(notification_service).to receive(:notify).with(:bet_changed, attributes)

    BetChangeNotifier.new(notification_service, attributes).notify
  end
end
