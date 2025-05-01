module DiscoveryEngine
  class ControlClient
    include Services

    def sync(controls)
      # Acquire lock
      # Get all controls from remote
      # Create controls that exist locally but not remotely
      # Update controls that exist remotely and locally
      # Get all serving configs from remote
      # Iterate over ALL_SERVING_CONFIGS and update each with new set of controls
      #   (needs to happen before deleting controls as attached controls cannot be deleted)
      #   ~ ALL_SERVING_CONFIGS.each { it.controls = controls.select { it.scs.include(sc) } }
      # Delete controls that do not exist locally but exist remotely
      # Release lock
    end
  end
end
