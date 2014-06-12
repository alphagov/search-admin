Feature: Worst bets
  As a search admin
  I want to be able to see the worst bets for a query in our search system
  So that better results are provided to the users.

  Scenario: Viewing worst bets for a query
    Given a query with a worst bet exists
    When I view the query
    Then the worst bet should be listed on the query page
