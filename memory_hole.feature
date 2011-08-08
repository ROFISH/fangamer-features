Feature: Memory Hole
  Sometimes, a user just needs to go down the memory hole and be forgotten.
  
  Scenario: Delete All Topics
    Given I am an Administrator
      And a user exists with a name of "EraseMe"
      And a topic exists by user "EraseMe"
      And I go to the last created message
     When I go to the Ubercms
     When I follow "Users"
      And I fill in "EraseMe" for "User:"
      And I press "Find"
     When I follow "Memory Hole"
      And I choose "topic_delete"
      And I press "DELETE PERMANENTLY"
     Then a user should not exist with a name of "EraseMe"
     Then the last created message should be erased
     Then the last created topic should be erased
     