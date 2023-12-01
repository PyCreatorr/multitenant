require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "invitation_accepted" do
    mail = UserMailer.invitation_accepted
    assert_equal "Invitation accepted", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
