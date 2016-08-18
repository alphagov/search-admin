Feature: Recommended links ElasticSearch export
  As a search admin
  I want to be able to dump all recommended links in ElasticSearch format
  So that they can be quickly reindexed

  @no-txn
  Scenario: Exporting a variety of recommended links
    Given a variety of recommended links exist
    When I run recommended links ElasticSearch exporter
    Then all recommended links should have been exported in the correct ElasticSearch format
