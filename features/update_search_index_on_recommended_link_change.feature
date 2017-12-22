Feature: Update search index on external change
  As a search admin
  I want my external link changes to be sent to the correct index
  So that they can be used to alter the results of searches

  @stub_recommended_links
  Scenario: Creating an external link
    When I create a new external link
    Then the external link should have been sent to the mainstream index
    When I edit the external link named "Tax online" with link "https://www.tax.service.gov.uk/" to be named "The new tax online"
    Then the edited external link should have been sent to the mainstream index
    When I delete the external link named "The new tax online" with link "https://www.tax.service.gov.uk/"
    Then the external link "https://www.tax.service.gov.uk/" should have been deleted in the mainstream index
