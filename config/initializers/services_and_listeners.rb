module SearchAdmin
  def self.services(name, service = nil)
    @services ||= {}
    @services[name] = service if service
    @services[name]
  end
end

# Services
SearchAdmin.services(:rummager_index, Rummageable::Index.new(Plek.current.find('search'), 'metasearch'))
SearchAdmin.services(:message_bus, MessageBus.new)

# Listeners
SearchAdmin.services(:message_bus)
  .register_listener(:bet_changed, RummagerNotifier)
