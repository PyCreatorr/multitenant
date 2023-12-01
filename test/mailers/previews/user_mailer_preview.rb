# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/invitation_accepted
  def invitation_accepted
    UserMailer.with(invited_user: User.last, user: User.first, tenant: Tenant.last, role: "editor").invitation_accepted
  end

end
