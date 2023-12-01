require "test_helper"

class MemberMailerTest < ActionMailer::TestCase
  test "member_created" do
    mail = MemberMailer.member_created
    assert_equal "Member created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
