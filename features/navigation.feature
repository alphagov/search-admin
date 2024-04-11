Feature: Navigating across pages
  As a search admin
  I want to navigate between different parts of the site
  So that tasks can be performed more efficiently

  Scenario: Navigating from a specific external link back to the index of external links
    Given I am viewing a specific external link
    Then I can click a link to navigate to the index of external links
