class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.invitation_accepted.subject
  #
  def invitation_accepted
    @user = params[:user]
    @tenant = params[:tenant]
    @role = params[:role]
    @greeting = "Hi"
    #@current_user = params[:current_user]
    #@current_user = User.find(@tenant.members.where(roles: {"admin"=>true}).first.user_id)
    @invited_user = params[:invited_user]
    attachments['referral_app_icon.jpg'] = File.read('app/assets/images/referral_app_icon.jpg')

    mail(
      from: "testThisApp@yahoo.com",
      to: email_address_with_name(@user.email, @user.email),
      # cc: User.all.pluck(:email), 
      bcc: @invited_user.email, 
      subject: "New member #{@user.email} has been added to the workspace '#{@tenant.name}'!"
    )
  end
end
