Feature: Best bets ElasticSearch export
  As a search admin
  I want to be able to dump all best bets in ElasticSearch format
  So that they can be quickly reindexed

  @no-txn
  Scenario: Exporting a variety of best bets
    Given a variety of best bets exist
    When I run best bet ElasticSearch exporter
    Then all best bets should have been exported in the correct ElasticSearch format
