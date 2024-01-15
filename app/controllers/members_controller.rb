class MembersController < AuthorizedController
    # after_invitation_accepted :email_invited_by
    #before_action :set_current_tenant, only: [:index, :invite]
    def index
        #@members = Member.find(params[:tenant_id].
        @members = @current_tenant.members


        #respond_to do |format|



        # format.turbo_stream  { render partial: "members", 
        #     locals: { members: @members  }
        #   }

        # end
    end

    def select
        #@members = Member.find(params[:tenant_id].
        
        @members = @current_tenant.members

        # debugger 
        respond_to do |format|
            
            format.turbo_stream  { render partial: "members/members_all", 
                locals: { members: @members  }
            }
            # format.html { render :index }

        end
    end



    def invite
        email = params[:email]
        #binding.break
        unless !email.blank?  
            flash[:danger] = "No email is provided!"
            return redirect_to tenant_members_path(@current_tenant)
        end
        # IF USER IS ALREADY EXIST & HAVE NO MEMBERSHIP 
        user_mail = User.find_by(email: email)
        if user_mail.present? && !(User.find_by(email: email).tenants.include?(@current_tenant))
            UserMailer.with(user: user_mail, invited_user: current_user, tenant: @current_tenant, role: "editor").invitation_accepted.deliver_later 
        end

        user = User.find_by(email: email) || User.invite!({email: email}, current_user,  tenant: @current_tenant)

        unless user.valid?  
            flash[:danger] = "Email invalid"
            return redirect_to tenant_members_path(@current_tenant)
        end

        user.members.find_or_create_by(tenant: @current_tenant, roles: {admin:false, editor: true})

        #UserMailer.with(user: @user).welcome_email.deliver_later

        # MemberMailer.with(current_user: current_user, user: user, tenant: @current_tenant, role: "editor").member_created.deliver_later
        # TODO: Email that user has been added to this workspace
        
        flash[:success] = "Member with #{email} is invited!"
        redirect_to tenant_members_path(@current_tenant)

    end

    # private

    # def email_invited_by
    #     flash[:success] = "Member with #{email} has accepted the invitation!"
    # end

    # def authorize_member
    #     unless @tenant.users.include?(current_user)
    #       flash[:danger] = "You are not a member"
    #       return redirect_to root_path
    #     end
    # end

    # def set_current_tenant
    #     @current_tenant = Tenant.find(params[:tenant_id])        
    # end

end
