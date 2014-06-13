Feature: Best bets
  As a search admin
  I want to be able to provide hints to our search system
  So that better results are provided to the users.

  Scenario: Creating best bets
    When I create a best bet
    Then the query should be listed on the index page
    And the best bet should be listed on the query page

  Scenario: Editing best bets
    Given a query exists
    When I edit a best bet
    Then the edited best bet should be listed on the query page

  Scenario: Deleting best bets
    Given a query exists
    When I delete the first best bet
    Then the best bet should not be listed on the query page
