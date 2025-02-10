# Enhances a controller with the ability to set "navigation areas" via class attributes.
#
# This allows a controller to define that it is part of a certain area of the app for navigation
# purposes, either by setting the class attribute on the controller, or more dynamically by defining
# a method.
module HasNavigationAreas
  extend ActiveSupport::Concern

  included do
    class_attribute :primary_navigation_area

    helper_method :primary_navigation_area
  end
end
