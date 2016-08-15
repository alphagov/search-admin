Feature: Recommended links
  As as a search admin
  I want to be able to create recommended links
  So that better results are provided to the users

  Scenario: Viewing a recommended link
    When I create a new recommended link
    And I visit the recommended link
    Then I should see the recommended links search results on the page

  Scenario: Creating a recommended link
    When I create a new recommended link
    Then the recommended link named "Tax online" should be listed on the recommended links index

  Scenario: Editing a recommended link
    Given a recommended link exists named "Tax online" with link "https://www.tax.service.gov.uk/"
    When I edit the recommended link named "Tax online" with link "https://www.tax.service.gov.uk/" to be named "The new tax online"
    Then the edited recommended link named "The new tax online" should be listed on the recommended links index

  Scenario: Deleting a recommended link
    Given a recommended link exists named "Tax online" with link "https://www.tax.service.gov.uk/"
    When I delete the recommended link named "Tax online" with link "https://www.tax.service.gov.uk/"
    Then the recommended link named "Tax online" should not be listed on the recommended links index
