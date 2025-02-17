# Enhances a model with lifecycle callbacks to synchronise it with a remote resource using a client
# class (conventionally located in `app/clients/`).
#
# Example:
# ```ruby
# class Foo < ApplicationRecord
#   include RemoteSynchronizable
#   remote_synchronize with: BarApi::FooClient
# end
# ```
#
# If the remote operation fails, the record will not be created/updated/destroyed, and will be
# marked invalid.
module RemoteSynchronizable
  extend ActiveSupport::Concern

  included do
    # Client class to use for synchronisation
    class_attribute :client_class

    # Create and update the remote resource using the client during ActiveRecord lifecycle events.
    #
    # Normally we would avoid using ActiveRecord callbacks to make network calls, but as the core
    # purpose of Search Admin is to provide an interface to manage resources on various remote APIs,
    # this is part of its core domain.
    #
    # Note the remote creation needs to be _after_ the record is created, as the record needs to
    # have an ID. This won't persist if the remote creation fails as the transaction would be rolled
    # back.
    after_create :create_remote, unless: :skip_remote_synchronization_on_create
    before_update :update_remote
    before_destroy :destroy_remote

    # Skips the creation of the remote synchronisation on create.
    #
    # This allows to create new instances of a record without a remote counterpart, for example
    # when importing existing remote resources, or as part of test setup (see `spec/factories.rb`).
    attr_accessor :skip_remote_synchronization_on_create
  end

  class_methods do
    # Set the class to be used for synchronisation for this model. It must allow initialisation with
    # a record, and respond to `#create`, `#update` and `#delete`.
    def remote_synchronize(with:)
      self.client_class = with
    end
  end

private

  def create_remote
    client.create(self) # rubocop:disable Rails/SaveBang (not an ActiveRecord model)
  rescue ClientError
    raise ActiveRecord::RecordInvalid, self
  end

  def update_remote
    client.update(self) # rubocop:disable Rails/SaveBang (not an ActiveRecord model)
  rescue ClientError
    raise ActiveRecord::RecordInvalid, self
  end

  def destroy_remote
    client.delete(self)
  rescue ClientError
    throw :abort
  end

  def client
    @client ||= client_class.new
  end
end
