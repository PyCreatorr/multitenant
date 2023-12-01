# Preview all emails at http://localhost:3000/rails/mailers/member_mailer
class MemberMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/member_mailer/member_created
  def member_created
    MemberMailer.with(current_user: User.last, user: User.first, tenant: Tenant.last, role: "editor").member_created
  end

end
