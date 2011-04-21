Feature: Topics
  In order to make posts, they must reside in a topic.
  
  @javascript
  Scenario: Edit Topic Via Ajax
    Given I am an Administrator
     When I am on any topic
      And I follow "Edit" within "#page-header"
     When I wait for 0.5 seconds
     Then I should see "Title:" within "#edittopicform label"