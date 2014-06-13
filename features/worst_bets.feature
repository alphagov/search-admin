Feature: Worst bets
  As a search admin
  I want to be able to see the worst bets for a query in our search system
  So that better results are provided to the users.

  Scenario: Creating a worst bet for a query
    When I create a worst bet for a query
    Then the worst bet should be listed on the query page

  Scenario: Viewing worst bets for a query
    Given a query with a worst bet exists
    Then the worst bet should be listed on the query page
