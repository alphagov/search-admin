module SearchAdmin
  def self.services(name, service = nil)
    @services ||= {}
    @services[name] = service if service
    @services[name]
  end
end

# Services
SearchAdmin.services(:rummager_index, Rummageable::Index.new(Plek.current.find('search'), 'metasearch'))
