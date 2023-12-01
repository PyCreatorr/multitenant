class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  after_invitation_accepted :email_invited_by


  has_many :members, dependent: :destroy
  has_many :tenants, through: :members, dependent: :destroy

  def email_invited_by
    # binding.break
    @user = User.find(id)
    @tenant = User.find(id).tenants.last
    @invited_user = User.find(id).invited_by
    @roles = User.find(id).members.last.roles

    #MemberMailer.with(current_user: current_user, user: user, tenant: @current_tenant, role: "editor").member_created.deliver_later
    #@current_user = User.find(@tenant.members.where(roles: {"admin"=>true}).first.user_id)
    # UserMailer.with(user: user, tenant: @current_tenant, role: "editor").invitation_accepted.deliver_later
    #UserMailer.with(user: User.find(), tenant: params[:tenant], role: "editor").invitation_accepted.deliver_later
    UserMailer.with(user: @user, invited_user: @invited_user, tenant: @tenant, role: @roles).invitation_accepted.deliver_later
  end
end
