Feature: Login
  To ensure the safety of the application
  A regular user of the system
  Must authenticate before using the app
 

  Scenario Outline: Failed Login
    Given I am not authenticated
    When I go to /login
    And I fill in "login" with "<mail>"
    And I fill in "password" with "<password>"
    And I press "Log In"
    Then the login request should fail
    Then I should see an error message
  
    Examples:
      | mail           | password       |
      | not_an_address | nil            |
      | not@not        | 123455         |
      | 123@abc.com    | wrong_paasword |


  Scenario: Successful login
    Given I am not authenticated
    And a user exists with login "johnlester@gmail.com" and password "johnpwd" 
    When I go to /login
    And I fill in "login" with "johnlester@gmail.com"
    And I fill in "password" with "johnpwd"
    And I press "Log In"
    Then the login request should succeed
    And I should see "Characters controller, index action"


    
