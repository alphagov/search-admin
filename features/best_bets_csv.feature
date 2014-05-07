Feature: Best bets CSV
  As a search admin
  I want to be able to list all best bets as a CSV
  So that I can check for best bets referring to dead URLs.

  Scenario: There are some best bets
    Given there are some best bets
    When I view the best bets CSV
    Then I should see all best bets listed in the CSV
