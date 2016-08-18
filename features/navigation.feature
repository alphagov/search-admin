Feature: Navigating across pages
  As a search admin
  I want to navigate between different parts of the site
  So that tasks can be performed more efficiently

  Scenario: Navigating from a specific query back to the index of queries
    Given I am viewing a specific query
    Then I can click a link to navigate to the index of queries

    Scenario: Navigating from a specific recommended link back to the index of recommended links
      Given I am viewing a specific recommended link
      Then I can click a link to navigate to the index of recommended links
