Feature: organizer edits an existing challenge
 
  As a registered organizer
  So that I can edit existing information kept on my competitions
  I want to be able to click on one of my challenges and reinput all information
  that reflect the changes I want

Background: challenges have been added to the database
  
  Given I am a new, authenticated user

  And the following challenges exist:
  | title                   | description   | start_time   | user_id |
  | Flight path             | Optimize cost | 25-Nov-1992  |    1    |

  And I am on the Chalearn's Challenges page

Scenario: Edit a challenge
    Given I am on the Chalearn's Challenges page
    When I follow "edit_1"
    Then I should be on the edit page for "Flight path"

    When I fill in "Title" with "Flight path"
    And I fill in "Description" with "Model the financial crisis"
    And I press "submit"

    Then I should be on the details page for "Flight path"
    And I should see "Flight path"