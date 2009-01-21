Feature: Manage characters
  To make the game individualized
  A user
  Should be able to create, see, and delete characters they use to play the game

  Scenario: List characters
    Given I am logged in as "johnlester@gmail.com" with password "pwd"
    And I have 2 characters
    When I go to /characters
    Then I should see "2 characters"

  Scenario: Create new character  
    Given I am logged in as "johnlester@gmail.com" with password "pwd"
    And I have 2 characters
    When I go to /characters
    And I follow "New"
    And I fill in "name" with "Newguy"
    And I press "Create"
    And I go to /characters
    Then I should see "Newguy"
    
  Scenario: Start a new game
    Given I am logged in as "johnlester@gmail.com" with password "pwd"
    And I have a character named "Myguy"
    When I go to /characters
    And I follow "Start game with Myguy"
    Then I should see "Waiting for opponent"
    
  Scenario: Start a game with two characters from the same user
    Given I am logged in as "johnlester@gmail.com" with password "pwd"
    And I have a character named "Myguy"
    And I have a character named "Otherguy"
    When I go to /characters
    And I follow "Start game with Myguy"
    And I follow "Join existing game with Otherguy"
    And I follow "Play vs. Myguy"
    Then I should see "Round 1"
    
    