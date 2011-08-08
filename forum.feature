Feature: Forum
  Generic forum tests
  
  @allow-rescue
  Scenario: User is superbanned
    Given I am logged in as a regular user with banned set to "true"
     When I am on the forum frontpage
     Then I should see "You are banned."
