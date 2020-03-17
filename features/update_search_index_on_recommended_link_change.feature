Feature: Update publishing API on external change
  As a search admin
  I want my external link changes to be published
  So that they can be used to alter the results of searches

  @stub_recommended_links
  Scenario: Creating an external link
    When I create a new external link
    Then the external link should have been published
    When I edit the external link named "Tax online" to be named "The new tax online"
    Then the external link should have been republished
    When I delete the external link named "The new tax online"
    Then the external link should have been unpublished
