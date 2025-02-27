# Enhances a model with methods to synchronise it with a remote resource using a client
# class (conventionally located in `app/clients/`).
#
# Example:
# ```ruby
# class Foo < ApplicationRecord
#   include RemoteSynchronizable
#   self.remote_synchronizable_client_class = BarApi::FooClient
# end
# ```
#
# If the remote operation fails, the record will not be created/updated/destroyed, and will be
# marked invalid.
module RemoteSynchronizable
  extend ActiveSupport::Concern

  included do
    # Client class to use for synchronisation
    class_attribute :remote_synchronizable_client_class
  end

  # Saves the record and creates or updates its corresponding remote resource.
  def save_and_sync
    transaction do
      return false unless save

      sync
    end
  end

  # Destroys the record and deletes its corresponding remote resource.
  def destroy_and_sync
    transaction do
      return false unless destroy

      sync
    end
  end

  # Synchonises the record with its corresponding remote resource, creating, updating or deleting it
  # depending on the record's state.
  def sync
    if previously_new_record?
      client.create(self) # rubocop:disable Rails/SaveBang (not an ActiveRecord model)
    elsif destroyed?
      client.delete(self)
    else
      client.update(self) # rubocop:disable Rails/SaveBang (not an ActiveRecord model)
    end
  rescue StandardError => e
    GovukError.notify(e)
    Rails.logger.error(e)

    errors.add(:base, :remote_error, error_message: e.cause&.message || e.message)
    raise ActiveRecord::Rollback
  end

private

  def client
    @client ||= remote_synchronizable_client_class.new
  end
end
