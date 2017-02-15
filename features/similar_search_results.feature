Feature: Similar search results
  As as a search admin
  I want to be able to search for similar results
  So I know what related content there is for a particular page

  Scenario: Viewing more like this results
    When I visit the similar search results form
    And I type in a valid GOV.UK link with related items
    Then I should see all related items


