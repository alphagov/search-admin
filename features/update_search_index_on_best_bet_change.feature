Feature: Update search index on best bet change
  As a search admin
  I want my best bet changes to be sent to the metasearch index
  So that they can be used to alter the results of searches

  @stub_best_bets
  Scenario: Creating several exact best bets
    When I create several exact best bets for the same query
    Then the query should have been sent to the metasearch index
    When I delete one of the best bets
    Then the remaining merged best bets should have been sent to the metasearch index
    When I delete all the best bets
    Then the best bets should have been deleted in the metasearch index

  @stub_best_bets_with_404
  Scenario: Can successfully delete best bet that does exist in Rummager
    Given a query exists
    When I delete the query
    Then the query should not be listed on the query index

  @stub_best_bets
  Scenario: Deleting last bet will delete the best bet from Rummager
    Given a query exists
    When I delete all the best bets
    Then the best bets should have been deleted in the metasearch index

  @stub_best_bets_with_500
  Scenario: Error deleting from Rummager will block local delete of query
    Given a query exists
    When I delete the query
    Then I should be a notified of the error
    And the query should still be listed on the query index

  @stub_best_bets_with_500
  Scenario: Error deleting from Rummager will block local delete of best bet
    Given a query exists
    When I delete the last bet
    Then I should be a notified of the error
    And the query should still be listed on the query index with best bet

  @stub_best_bets_with_500
  Scenario: Error creating best bet in Rummager will block local creation of best bet
    When I create a best bet
    Then I should be a notified of the error
    And no query should be listed on the query index
