Feature: Recommended links CSV
  As a search admin
  I want to be able to list all recommended links as a CSV
  So that I can check for recommended links referring to dead URLs.

  Scenario: There are some recommended links
    Given there are some recommended links
    When I view the recommended links CSV
    Then I should see all recommended links listed in the CSV
