Feature: Swear Filter
  In order to have a better community
  a swear filter may have to be imposed.
    
  Scenario Outline: Test different swears by posting.
    Given I am logged in as a regular user
      And the following swear word exists:
      | word   | mask   | case_sensitive | simple |
      | <word> | <mask> | <cs>           | <smpl> |
    When I start a new topic in "General Discussion" with:
      | topic_name | topic_byline | message_body |
      | lol ur an <naughty> | <naughty> butts | hahah <naughty> butt! |
    Then the topic should have a title of "lol ur an <expected>"
      And the topic should have a byline of "<expected> butts"
      And the topic should have an op body of "<p>hahah <expected> butt!</p>"
    
  Examples:
    | word          | mask   | naughty | expected | cs    | smpl  |
    | @$$           | butt   | @$$     | butt     | false | true  |
    | ass           | butt   | ass     | butt     | false | true  |
    | Rofish        | ROFISH | Rofish  | ROFISH   | true  | true  |
    | Rofish        | ROFISH | Rofish  | ROFISH   | false | true  |
    | Rofish        | ROFISH | rofish  | ROFISH   | false | true  |
    | Rofish        | ROFISH | rofish  | rofish   | true  | true  |
    | sh[i1!]t(ty)? | --     | shitty  | --       | false | false |