module SearchAdmin
  def self.services(name, service = nil)
    @services ||= {}
    @services[name] = service if service
    @services[name]
  end
end

# Services
SearchAdmin.services(:rummager_index, Rummageable::Index.new(Plek.current.find('search'), 'metasearch'))

require 'gds_api/rummager'

# Extend the adapters to allow us to request URLs directly.
module GdsApi
  class Rummager < Base
    def get(path)
      request_url = "#{base_url}#{path}"
      get_json(request_url)
    end

    def delete!(path)
      request_url = "#{base_url}#{path}"
      delete_json!(request_url)
    end
  end
end

# Don't use caching to prevent just-deleted docs to show up.
rummager = GdsApi::Rummager.new(Plek.current.find('search'), disable_cache: true)
SearchAdmin.services(:rummager, rummager)
