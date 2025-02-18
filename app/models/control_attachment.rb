class ControlAttachment < ApplicationRecord
  belongs_to :control
  belongs_to :serving_config
end
