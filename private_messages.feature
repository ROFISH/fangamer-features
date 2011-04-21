Feature: Private Messages
  In order for users to better collaborate or moderate,
  Private Messages are used to send a message from one user to another.
  
  # Hash tags in front mean a comment, so it's ignored in the text.
  #
  # @allow-rescue means that when an error is thrown (such as the ability to
  # not log in), it does error handling instead of testing the error.
  # Without @allow-rescue, instead the last line would be:
  #
  # Then I should get a LoginRequired error
  #
  # But the point is to actually test what joe user sees, not the code.
  #
  # Also as a random note, only some errors are 'rescued', like LoginRequired,
  # or SecurityError or UserBanned. Other errors are just displayed to the user
  # as a 'Horrible Error' and usually implies a programming typo error and not
  # a rescuable error.
  #
  @allow-rescue 
  Scenario: No logged out users
    Given I am not logged in
     When I am on the pm inbox page
     Then I should be on the login page
  
  Scenario: PM Inbox loads and shows PMs
    Given I am logged in as a regular user
      And I have an unread PM with title "lol am a title" and body "deal with it 8)"
      And I have 1 read PM
     When I am on the pm inbox page
     Then I should be on the pm inbox page
      And I should see "lol am a title" within ".unseen"
     When I follow "lol am a title"
     #implies that the page loaded okay by seeing the text in a body we know about
     Then I should see "deal with it" 
  
  Scenario: Should be able to write a PM
    Given I am logged in as a regular user
      And I am on the new pm page
     When I fill in the following:
          | PrivateMessage_sendto         | ROFISH        |
          | PrivateMessage_title          | sup yo        |
          | PrivateMessage_body_original  | Hey there! :D |
      And I press "Send PM!"
     Then I should be on the pm inbox page
     When I follow "Sent Box"
     Then I should be on the pm sentbox page
      And I should see "sup yo"
     When I follow "sup yo"
     Then I should see "Hey there! :D"
  
  Scenario: Smilies work on PMs
    Given I am logged in as a regular user
      And the following smilie exists:
          | name     | regexp | url |
          | ColonDee | :D     | /include/images/smilies/colondee.png |
      And I have an unread PM with title "this is a smilie" and body "cool man :D"
     When I am on the pm inbox page
      And I follow "this is a smilie"
     Then I should have the image "/include/images/smilies/colondee.png" within ".post-body"
  
  Scenario: Swears work on PMs
    Given I am logged in as a regular user
      And the following swear word exists:
      | word | mask |
      | ass  | butt |
      And I have an unread PM with title "i h8 u" and body "ur an ass"
     When I am on the pm inbox page
      And I follow "i h8 u"
     Then I should see "ur an butt"
     
  Scenario: Reading a PM marks it as read
    Given I am logged in as a regular user
      And I have 1 unread PM
      And I have an unread PM with title "unread pm" and body "now it's not!"
     When I am on the pm inbox page
     Then I should see "unread pm" within any "tr.unseen a"
     When I follow "unread pm"
      And I am on the pm inbox page
     Then I should not see "unread pm" within any "tr.unseen a"
  
  Scenario: Clicking on mark as unread marks the PM as unread
    Given I am logged in as a regular user
      And I have a read PM with title "mark me as unread" and body "now it's not!"
     When I am on the pm inbox page
     Then I should not see "mark me as unread" within any "tr.unseen a"
     When I press "Mark PM as Unread"
     Then I should be on the pm inbox page
      And I should see "mark me as unread" within any "tr.unseen a"
  
  Scenario: Clicking on delete hides the PM
   Given I am logged in as a regular user
     And I have a read PM with title "delete me!" and body "now it's not!"
    When I am on the pm inbox page
    Then I should see "delete me" within any "tr a"
    When I press "Delete PM"
    Then I should be on the pm inbox page
     And I should not see "delete me" within any "tr a"
       # also check to be sure it didn't delete from the sender's sent box
       # the default sender of PMs is "Administrator" or "ROFISH", so look
       # in their sent box.
   Given I am an Administrator
    When I am on the pm sentbox page
    Then I should see "delete me" within any "tr a"
  
  Scenario: Shouldn't be able to read PMs that aren't yours
    Given I am logged in as a regular user
      And I have a read PM with title "dont look at me!" and body "super secret"
     When I am on the pm inbox page
     Then I should see "dont look at me!" within any "tr a"
     When I am on the last created PM page
     Then I should see "super secret"
        # log in as a second user
    Given I am logged in as a regular user
     When I am on the pm inbox page
     Then I should not see "dont look at me!" within any "tr a"
     When I am on the last created PM page
     Then I should be on the pm inbox page
     Then I should see "That message can't be found. Perhaps you don't have access to read it?"
  