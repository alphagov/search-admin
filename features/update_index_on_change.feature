Feature: Best bets CSV
  As a search admin
  I want my best bet changes to be sent to the metasearch index
  So that they can be used to alter the results of searches

  Scenario: Creating several exact best bets
    When I create several exact best bets for the same query
    Then the merged best bets should have been sent to the metasearch index
