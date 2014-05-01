Feature: Best bets
  As a search admin
  I want to be able to provide hints to our search system
  So that better results are provided to the users.

  Scenario: Creating best bets
    When I create a best bet
    Then the best bet should be available on the index page
