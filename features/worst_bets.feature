Feature: Worst bets
  As a search admin
  I want to be able to see the worst bets for a query in our search system
  So that better results are provided to the users.

  @stub_best_bets
  Scenario: Admin user creating a worst bet for a query
    Given I am an admin user
    When I create a worst bet for a query as an admin
    Then the worst bet should be listed on the query page

  @stub_best_bets
  Scenario: Admin user creating a worst bet for a query
    Given I am a basic user
    When I create a worst bet for a query
    Then the worst bet should be listed on the query page

  Scenario: Viewing worst bets for a query
    Given a query with a worst bet exists
    Then the worst bet should be listed on the query page
