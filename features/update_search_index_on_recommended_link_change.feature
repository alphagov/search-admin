Feature: Update search index on recommended change
  As a search admin
  I want my recommended link changes to be sent to the correct index
  So that they can be used to alter the results of searches

  Scenario: Creating a recommended link
    When I create a new recommended link
    Then the recommended link should have been sent to the mainstream index
    When I edit the recommended link named "Tax online" with link "https://www.tax.service.gov.uk/" to be named "The new tax online"
    Then the edited recommended link should have been sent to the mainstream index
    When I delete the recommended link named "The new tax online" with link "https://www.tax.service.gov.uk/"
    Then the recommended link "https://www.tax.service.gov.uk/" should have been deleted in the mainstream index
