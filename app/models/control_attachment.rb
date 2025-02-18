class ControlAttachment < ApplicationRecord
  belongs_to :control, counter_cache: true
  belongs_to :serving_config, counter_cache: true
end
