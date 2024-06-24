class Control < ApplicationRecord
  validates :display_name, presence: true

  after_create :create_on_discovery_engine

  # A unique identifier for the control in Discovery Engine
  def control_id
    "search-admin-#{id}"
  end

private

  def create_on_discovery_engine
    Services.discovery_engine_control.create_control(
      parent: Rails.configuration.discovery_engine_engine,
      control_id:,
      control: control_data,
    )
  rescue StandardError => e
    GovukError.notify(e)
    Rails.logger.error(e)
    errors.add(:base, :discovery_engine_error)

    raise ActiveRecord::Rollback
  end

  def control_data
    # see https://cloud.google.com/ruby/docs/reference/google-cloud-discovery_engine-v1/latest/Google-Cloud-DiscoveryEngine-V1-Control
    {
      # TODO!
      # solution_type: :SOLUTION_TYPE_SEARCH,
      # use_cases: [:SEARCH_USE_CASE_SEARCH],
      display_name:,
    }
  end
end
