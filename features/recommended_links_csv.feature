Feature: External links CSV
  As a search admin
  I want to be able to list all external links as a CSV
  So that I can check for external links referring to dead URLs.

  Scenario: There are some external links
    Given there are some external links
    When I view the external links CSV
    Then I should see all external links listed in the CSV
