Feature: Addition
  In order to avoid silly mistakes
  As a math idiot 
  I want to be told the sum of two numbers
    
  Scenario: Register new private_messages

Feature: Superbans
A superbanned user cannot see the forum or use any of its features.

  Scenario: User is superbanned
    Given I am logged in
     When I am superbanned
     Then I should see "You are banned from the forum."