Feature: Best bets CSV
  As a search admin
  I want my best bet changes to be sent to the metasearch index
  So that they can be used to alter the results of searches

  Scenario: Creating several exact best bets
    When I create several exact best bets for the same query
    Then the query should have been sent to the metasearch index
    When I delete one of the best bets
    Then the remaining merged best bets should have been sent to the metasearch index
    When I delete all the best bets
    Then the best bets should have been deleted in the metasearch index
