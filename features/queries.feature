Feature: Queries
  As as a search admin
  I want to be able to create queries which hold bets
  So that I can organise my bets in a clearer way

  Scenario: Creating a query
    When I create a new query
    Then the query should be listed on the query index

  Scenario: Editing a query
    Given a query exists
    When I edit the query
    Then the edited query should be listed on the query index

  Scenario: Deleting a query
    Given a query exists
    When I delete the query
    Then the query should not be listed on the query index
