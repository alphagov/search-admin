Feature: Managing results
  As as a search admin
  I want to be able to inspect search results
  So that I know why some results are present

  Scenario: Viewing a result
    When I visit the results form
    And I type in a valid GOV.UK link
    Then I should see all information about the link

  Scenario: Removing a result
    When I visit the results form
    And I type in a valid GOV.UK link
    And I click on the button to remove the result
    Then the result should have been removed from the index

  Scenario: Searching for an invalid link
    When I visit the results form
    And I type in an non-existing GOV.UK link
    Then I should see that the link is invalid

  Scenario: Removing a link that fails
    When I visit the results form
    And I type in a locked GOV.UK link
    And I click on the button to remove the locked result
    Then I should see a message with locking error
