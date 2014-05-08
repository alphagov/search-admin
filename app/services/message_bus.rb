# This class can defer to the GOV.UK-wide message bus once it is in use.
# Some event types will need to be changed to align with other applications.
class MessageBus

  def initialize
    @listeners = Hash.new {|hash, key| hash[key] = [] }
  end

  def register_listener(event_type, listener)
    @listeners[event_type] << listener

    self
  end

  def notify(event_type, event_data)
    @listeners[event_type].each do |listener|
      listener.call(event_data)
    end

    self
  end

end
