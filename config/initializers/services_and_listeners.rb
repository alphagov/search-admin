require "gds_api/rummager"

# Extend the adapters to allow us to request URLs directly.
module GdsApi
  class Search < Base
    def get(path)
      request_url = "#{base_url}#{path}"
      get_json(request_url)
    end

    def delete!(path)
      request_url = "#{base_url}#{path}"
      delete_json(request_url)
    end
  end
end
