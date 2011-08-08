Feature: Infraction Points System
  In order to create order, the infraction points system does things
  
  Scenario: Unlock the points panel
    Given I am an Administrator
     When I go to the Ubercms
     Then I should not see "Infraction" within any "a[href='/ubercms/infraction_groups']"
     When I follow "Preferences" within "#system_preferences"
      And I fill in "30" for "preferences_infraction_expiry"
      And I press "Save"
     Then I should see "Infraction" within any "a[href='/ubercms/infraction_groups']"
     When I go to the infraction groups page
      And I follow "Create Infraction Group"
      And I fill in the following:
          | Name:   | Token Infraction |
          | Points: | 1 |
      And I press "submit"
      And I follow "Create Infraction Group"
      And I fill in the following:
          | Name:   | Minor Infraction |
          | Points: | 2 |
      And I press "submit"
      And I follow "Create Infraction Group"
      And I fill in the following:
          | Name:   | Major Infraction |
          | Points: | 3 |
      And I press "submit"
      And I follow "Create Infraction Group"
      And I fill in the following:
          | Name:   | Uber Infraction |
          | Points: | 6 |
      And I press "submit"
     Then I should see "Token Infraction"
     Then I should see "Minor Infraction"
     Then I should see "Major Infraction"
     Then I should see "Uber Infraction"
     When I go to the infraction punishments page
      And I follow "Create Infraction Punishment"
      And I fill in the following:
          | Name: | 72 Hour Punishment |
          | Points: | 3 |
          | punishment_new0_expire_input | 72 hours |
      And I choose "punishment_new0_until_points_expire_0"
      And I select "Ban From Forum" from "punishment_new0_name"
      And I press "submit"
      And I follow "Create Infraction Punishment"
      And I fill in the following:
          | Name: | 2 Week Punishment |
          | Points: | 6 |
          | punishment_new0_expire_input | two weeks |
      And I choose "punishment_new0_until_points_expire_0"
      And I select "Ban From Forum" from "punishment_new0_name"
      And I press "submit"
      And I follow "Create Infraction Punishment"
      And I fill in the following:
          | Name: | Permanent Ban |
          | Points: | 8 |
      And I choose "punishment_new0_until_points_expire_1"
      And I check "infraction_punishment_disable_point_expiration"
      And I select "Ban From Forum" from "punishment_new0_name"
      And I press "submit"
     Then I should be on the infraction punishments page
     Then I should see "72 Hour Punishment"
     Then I should see "2 Week Punishment"
     Then I should see "Permanent Ban"
  
  Scenario: Reporting a message
    Given I am logged in as a regular user
      And a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
      And I go to the last created message
     When I follow "Report" within "the last created message"
     Then I should be on the last created message's new report page
     When I fill in "this guy is trolling" for "report_body"
      And I press "submit"
     Then I should be on the last created message's topic
      And I should see "Thanks for reporting the message." within "the last created message"
      And an open report of "this guy is trolling" should exist
  
  Scenario: Deleting a reported message
    Given I am an Administrator
      And a user exists with a name of "PunishMe"
      And a user exists with a name of "ReportsTooMuch"
      And a message exists by user "PunishMe"
      And an open report exists for the last created message with body "this guy is trolling" by "ReportsTooMuch"
     When I am on the forum frontpage
      And I follow "There is 1 open report"
     Then I should be on the last created report's take page
      And follow "Delete"
     Then I should be on the last created message's topic
      And I should see "The report was deleted."
      And an open report of "this guy is trolling" should not exist
      #And "ReportsTooMuch" has an ignore count of 1
  
  Scenario: Infracting a message
    Given I am an Administrator
      And a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
     When I am on the last created message's infract page
      And I check "Delete Message"
      And I check "Lock Topic"
      And I select "General Art" from "Move Topic"
      And I fill in the following:
        | Ban user from topic for:  | Two Weeks from now |
        | Reason for the User:      | stop trolling      |
        | Resolution for Mods Only: | he's being a jerk  |
      And I press "Infract!"
     Then I should see "Message was infracted" within "the last created message"
      And the last created message should be deleted
      And the last created message's topic should be locked
      And the last created message's topic should be moved to "General Art"
      And "PunishMe" should have a punishment of "ban_from_topic" for about "2 weeks"
  
  Scenario: Punished user gets points
    Given I am an Administrator
      And the GW1 punishments exists
    Given a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
      And I go to the last created message
     When I follow "Infract" within "the last created message"
      And I choose "Major Infraction"
      And I fill in "a reason" for "Reason"
      And I press "Infract!"
     Then I should see "Message was infracted" within "the last created message"
      And "PunishMe" should have 3 points
      And "PunishMe" should have a punishment of "ban_from_forum" for about "72 hours"
      And there should be 3 points for "PunishMe" from the last created message's infraction
  
  Scenario: Punished user's points decline
    Given the GW1 punishments exists
      And a user exists with a name of "PunishMe"
      And an infracted message exists by user "PunishMe" with level "Major Infraction"
      And "PunishMe" should have 3 points
      And I am logged in as "PunishMe"
     When I am on the forum front page
     Then I should see "You are temporarily banned from the forum."
     When 71 hours pass
      And I am on the forum front page
     Then I should see "You are temporarily banned from the forum."
     When 2 hours pass
      And I am on the forum front page
     Then I should not see "You are temporarily banned from the forum."
      And "PunishMe" should have 3 points
     When 30 days pass
      And I am on the forum front page
     Then "PunishMe" should have 2 points
     When 30 days pass
      And I am on the forum front page
     Then "PunishMe" should have 1 point
     When 30 days pass
      And I am on the forum front page
     Then "PunishMe" should have 0 points
  
  Scenario: In a non-points system, infracter gets PMed with reason and actions
    Given I am an Administrator
      And a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
      And I go to the last created message
     When I follow "Infract" within "the last created message"
      And I fill in "a reason" for "Reason"
      And I press "Infract!"
     Then I should see "Message was infracted" within "the last created message"
     
     When I am logged in as "PunishMe"
     When I am on the forum front page
     Then I should see "You have 1 new Private Messages!"
     When I am on the pm inbox page
     Then I should see "has been infracted!"
     When I follow "has been infracted!"
     Then I should see "a reason"
     Then I should not see "point"
  
  Scenario: In a points-based system, infracter gets PM with reason, actions, and what points are on his record when points are awarded
    Given the GW1 punishments exists
    Given I am an Administrator
      And a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
      And I go to the last created message
     When I follow "Infract" within "the last created message"
      And I fill in "a reason" for "Reason"
      And I choose "Major Infraction"
      And I press "Infract!"
     Then I should see "Message was infracted" within "the last created message"
     
     When I am logged in as "PunishMe"
     When I am on the pm inbox page
     Then I should see "has been infracted!"
     When I follow "has been infracted!"
     Then I should see "a reason"
     Then I should see "You have recieved 3 points for your infraction."
     Then I should see "You recieve the punishment “Suspend from Forum” for 72 hours"
     Then I should see "point"
  
  Scenario: In a points-based system, infracter gets PM with reason, actions, and what points are on his record when warned
    Given the GW1 punishments exists
    Given I am an Administrator
      And a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
      And I go to the last created message
     When I follow "Infract" within "the last created message"
      And I fill in "a reason" for "Reason"
      And I choose "Warning"
      And I press "Infract!"
     Then I should see "Message was infracted" within "the last created message"
   
     When I am logged in as "PunishMe"
     When I am on the pm inbox page
     Then I should see "has been infracted!"
     When I follow "has been infracted!"
     Then I should see "a reason"
     Then I should not see "point"
  
  Scenario: Punished user can get upgraded. A PM is sent.
    Given the GW1 punishments exists
      And I am an Administrator
      And a user exists with a name of "PunishMe"
      And an infracted message exists by user "PunishMe" with level "Major Infraction"
     When 24 hours pass
     When I go to the last created message
     Then I should see "(User was infracted for this post)"
     When I follow "Infract" within "the last created message"
      And I choose "Uber Infraction"
      And I fill in "a reason... Due to the heinousness of your post, I've upgraded it." for "Reason"
      And I press "Infract!"
     Then I should see "Infraction was edited" within "the last created message"
     
    Given I am logged in as "PunishMe"
     When I am on the pm inbox page
     Then I should see "was changed!"
     When I follow "was changed!"
     Then I should see "Your infraction was upgraded from 3 to 6 points. You now have a total of 6 points."
     Then I should see "Due to the heinousness of your post, I’ve upgraded it."
      And "PunishMe" should have 6 points
      # 13 days since one day already passed
      And "PunishMe" should have a punishment of "ban_from_forum" for about "13 days"
  
  Scenario: Punished user can be downgraded via editing the infraction. A PM is sent.
    Given the GW1 punishments exists
      And I am an Administrator
      And a user exists with a name of "PunishMe"
      And an infracted message exists by user "PunishMe" with level "Major Infraction"
     When 24 hours pass
     When I go to the last created message
     Then I should see "(User was infracted for this post)"
     When I follow "Infract" within "the last created message"
      And I choose "Warning"
      And I fill in "a reason... Due to the niceness of your post, I've downgraded it." for "Reason"
      And I press "Infract!"
     Then I should see "Infraction was edited" within "the last created message"
   
    Given I am logged in as "PunishMe"
     When I am on the pm inbox page
     Then I should see "was changed!"
     When I follow "was changed!"
     Then I should see "Your infraction was downgraded from 3 to 0 points. You now have a total of 0 points."
     Then I should see "Due to the niceness of your post, I’ve downgraded it."
      And "PunishMe" should have 0 points
      And "PunishMe" should not have a punishment of "ban_from_forum"
      
  Scenario: Punished user can be downgraded via editing the infraction from a higher infraction. A PM is sent.
    Given the GW1 punishments exists
      And I am an Administrator
      And a user exists with a name of "PunishMe"
      And an infracted message exists by user "PunishMe" with level "Uber Infraction"
     When 24 hours pass
     When I go to the last created message
     Then I should see "(User was infracted for this post)"
     When I follow "Infract" within "the last created message"
      And I choose "Major Infraction"
      And I fill in "a reason... Due to the niceness of your post, I've downgraded it." for "Reason"
      And I press "Infract!"
     Then I should see "Infraction was edited" within "the last created message"

    Given I am logged in as "PunishMe"
     When I am on the pm inbox page
     Then I should see "was changed!"
     When I follow "was changed!"
     Then I should see "Your infraction was downgraded from 6 to 3 points. You now have a total of 3 points."
     Then I should see "Due to the niceness of your post, I’ve downgraded it."
      And "PunishMe" should have 3 points
      # 72 hours - 24 hours that passed.
      And "PunishMe" should have a punishment of "ban_from_forum" for about "48 hours"
  
  Scenario: Create points from warning.
    Given the GW1 punishments exists
    Given I am an Administrator
      And a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
      And I go to the last created message
     When I follow "Infract" within "the last created message"
      And I fill in "a reason" for "Reason"
      And I choose "Warning"
      And I press "Infract!"
     Then I should see "Message was infracted" within "the last created message"
      And 24 hours pass
     When I follow "Infract" within "the last created message"
      And I fill in "opps forgot to give points" for "Reason"
      And I choose "Major Infraction"
      And I press "Infract!"
     Then I should see "Infraction was edited" within "the last created message"

    Given I am logged in as "PunishMe"
     When I am on the pm inbox page
     Then I should see "was changed!"
     When I follow "was changed!"
     Then I should see "Your infraction was upgraded from 0 to 3 points. You now have a total of 3 points."
     Then I should see "opps forgot to give points"
      And "PunishMe" should have 3 points
      # 48 hours since one day already passed
      And "PunishMe" should have a punishment of "ban_from_forum" for about "48 hours"
  
  Scenario: Cannot report an infracted post
    Given the GW1 punishments exists
    Given I am logged in as a regular user
      And a user exists with a name of "PunishMe"
      And an infracted message exists by user "PunishMe" with level "Major Infraction"
      And I go to the last created message
     When I follow "Report" within "the last created message"
     Then I should be on the last created message's topic
      And I should see "This message was already infracted." within "the last created message"
  
  Scenario: Punished user can be downgraded via ubercms page by manually expiring infraction. A PM is sent.
  
  Scenario: After sitting on a non-expiration punishment point for a long time, after getting a point expired manually, the infacter sits at one less point immediately after the expiration and degrades normally from there.
  
  Scenario: Moderators can defer reports and effectively ignore them.
  
  Scenario: In a non-points system, the moderator can post the message in a mod forum for review.
    Given I am an Administrator
      And a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
      And I go to the last created message
     When I follow "Infract" within "the last created message"
      And I fill in "a reason" for "Reason"
      And I select "ModForum" from "Post in Mod Forum:"
      And I press "Infract!"
     Then I should see "Message was infracted" within "the last created message"
     When I go to "ModForum" forum
      And I follow "Report: PunishMe"
     Then I should see "a reason"
  
  Scenario: In a points system, the moderator can post the message in a mod forum for review.
    Given the GW1 punishments exists
    Given I am an Administrator
      And a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
      And I go to the last created message
     When I follow "Infract" within "the last created message"
      And I fill in "a reason" for "Reason"
      And I select "ModForum" from "Post in Mod Forum:"
      And I choose "Major Infraction"
      And I press "Infract!"
     Then I should see "Message was infracted" within "the last created message"
     When I go to "ModForum" forum
      And I follow "Report: PunishMe"
     Then I should see "a reason"
      And I should see "3 were awarded for an infraction level of “Major Infraction”."
  
  Scenario: Infracting a message without "From Now"
    Given I am an Administrator
      And a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
     When I am on the last created message's infract page
      And I fill in the following:
        | Ban user from topic for:  | 24 hours |
        | Reason for the User:      | stop trolling      |
      And I press "Infract!"
     Then I should see "Message was infracted" within "the last created message"
      And "PunishMe" should have a punishment of "ban_from_topic" for about "24 hours"
  
  Scenario: An already reported message should show to the user the fact that the message was already reported.
    Given I am logged in as a regular user
      And a user exists with a name of "ReportsTooMuch"
      And a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
      And I go to the last created message
      And an open report exists for the last created message with body "this guy is trolling" by "ReportsTooMuch"
     When I follow "Report" within "the last created message"
     Then I should be on the last created message's topic
     Then I should see "This message was already reported. A moderator will soon resolve it." within "the last created message"
  
  Scenario: A deleted report should be allow a message to be reported again, and that report should result in an infraction, and then it cannot be reported.
    Given I am an Administrator
      And a user exists with a name of "ReportsTooMuch"
      And a user exists with a name of "PunishMe"
      And a message exists by user "PunishMe"
      And an open report exists for the last created message with body "this guy is trolling" by "ReportsTooMuch"
     When I am on the forum frontpage
      And I follow "There is 1 open report"
     Then I should be on the last created report's take page
      And follow "Delete"
     Then I should be on the last created message's topic
      And I should see "The report was deleted."
      And an open report of "this guy is trolling" should not exist
      
    Given I am logged in as a regular user
      And I go to the last created message
     When I follow "Report" within "the last created message"
     Then I should be on the last created message's new report page
     When I fill in "seriously this time" for "report_body"
      And I press "submit"
     Then I should be on the last created message's topic
      And I should see "Thanks for reporting the message." within "the last created message"
      And an open report of "seriously this time" should exist
      
    Given I am an Administrator
     When I am on the forum frontpage
      And I follow "There is 1 open report"
     Then I should be on the last created report's take page
      And I follow "Infract"
      And I fill in "a reason" for "Reason"
      And I press "Infract!"
     Then I should see "Message was infracted" within "the last created message"
      And a closed report of "seriously this time" resolved by "infract" should exist
      And a closed report of "this guy is trolling" resolved by "delete" should exist
      
    Given I am logged in as a regular user
      And I go to the last created message
     When I follow "Report" within "the last created message"
     Then I should see "This message was already infracted."