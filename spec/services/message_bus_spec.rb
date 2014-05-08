require 'spec_helper'

describe MessageBus do
  before do
    @email_notifier = double(:email_notifier, call: nil)
    @search_notifier = double(:search_notifier, call: nil)
    @publish_alerter = double(:publish_alerter, call: nil)

    @bus = MessageBus.new
      .register_listener(:change, @email_notifier)
      .register_listener(:change, @search_notifier)
      .register_listener(:publish, @publish_alerter)

    @change_data = double(:change_data)
    @publish_data = double(:publish_data)
  end

  it "sends messages to registered listeners" do
    @bus
      .notify(:change, @change_data)
      .notify(:publish, @publish_data)

    expect(@email_notifier).to have_received(:call).with(@change_data)
    expect(@search_notifier).to have_received(:call).with(@change_data)

    expect(@publish_alerter).not_to have_received(:call).with(@change_data)
    expect(@publish_alerter).to have_received(:call).with(@publish_data)
  end
end
