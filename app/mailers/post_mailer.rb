class PostMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.post_mailer.post_created.subject
  #
  def post_created
    # @user = params[:user]
    # @tenant = params[:tenant]
    # @role = params[:role]
    @greeting = "Hi"

    mail(
      from: "testThisApp@yahoo.com",
      to: User.first.email, 
      cc: User.all.pluck(:email), 
      bcc: "testthisapp@yahoo.com", 
      subject: "New post created!"
    )
  end
end
