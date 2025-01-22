# Allows a model to be synchronised with a remote resource in Discovery Engine.
#
# Use `discovery_engine_syncable as: ResourceClass` to specify which resource class should be used.
module DiscoveryEngineSyncable
  extend ActiveSupport::Concern

  included do
    class_attribute :discovery_engine_resource_class
  end

  class_methods do
    def discovery_engine_syncable(as:)
      self.discovery_engine_resource_class = as
    end
  end

  # Saves the record and creates or updates the corresponding resource in Discovery Engine depending
  # on whether the record is new. Rolls back in case of error, and adds details of any remote API
  # errors to the record so they can be displayed to the user.
  def save_and_sync
    transaction do
      return false unless save

      if previously_new_record?
        resource.create!
      else
        resource.update!
      end
    end
  rescue DiscoveryEngine::Error => e
    handle_error(e)
    false
  end

  # Destroys the record and deletes the corresponding resource in Discovery Engine. Rolls back in
  # case of error, and adds details of any remote API errors to the record so they can be displayed
  # to the user.
  def destroy_and_sync
    transaction do
      return false unless destroy

      resource.delete!
    end
  rescue DiscoveryEngine::Error => e
    handle_error(e)
    false
  end

private

  def handle_error(error)
    # If the error is about an invalid request, it's likely that the user can do something about it
    # and try again (for example, where Discovery Engine has stricter validations that we can't
    # replicate in this app).
    #
    # Otherwise, we don't need to show the possibly confusing error message error to the user, but
    # we should log it for investigation (and ideally the root cause error rather than our custom
    # wrapper).
    if error.invalid_request?
      errors.add(:base, :discovery_engine_invalid_request, message: error.message)
    else
      errors.add(:base, :discovery_engine_unrecoverable)
      Rails.logger.error(error.cause&.message || error.message)
      GovukError.notify(error.cause || error)
    end
  end

  def resource
    @resource ||= discovery_engine_resource_class.new(self)
  end
end
