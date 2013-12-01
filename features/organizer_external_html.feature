Feature: add external html ability

	As an organizer, I would like to create a new challenge by only providing an external link that overrides the typical implementation of a challenge
	So that when I create a challenge, I can have the ability to implement my challenge on an external site without completing all the information about the challenge again on the form
	I want to have the ability to input an external site instead of typing pure html into a text box

Background: challenges have been added to the database
  
	Given I am a new, authenticated user

	And the following challenges exist:
	| title                   | description   | start_time   | user_id |
	| Flight path             | Optimize cost | 25-Nov-1992  |    1    |

	And I am on the Chalearn's Challenges page

Scenario: Create a challenge
    Given I am on the Chalearn's Challenges page
    When I follow "New Challenge"
    Then I should be on the New Challenge page

    When I fill in "Title" with "Finance machine learning"
    And I fill in "Start time" with "30/October/2013"
    And I fill in "End time" with "31/October/2013"
    And I fill in "Description" with "Model the financial crisis"
    And I check "Use external URL"
    Then I should see the text field "Enter URL"

    When I fill in "Enter URL" with "http://www.test.com"
    And I press "submit"

    Then I should be on the details page for "Flight path"
    And I should see "Flight path"