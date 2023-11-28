class MembersController < ApplicationController
    before_action :set_current_tenant, only: [:index, :invite]
    def index
        #@members = Member.find(params[:tenant_id].
        @members = @current_tenant.members
    end

    def invite
        #binding.break
        email = params[:email]
        unless email.blank?  
            flash[:danger] = "No email is provided"
            return redirect_to tenant_members_path(@current_tenant)
        end
        user = User.find_by(email: email) || User.invite!({email: email}, current_user)

        unless user.valid?  
            flash[:danger] = "Email invalid"
            return redirect_to tenant_members_path(@current_tenant)
        end

        user.members.find_or_create_by(tenant: @current_tenant, roles: {admin:false, editor: true})
        
        flash[:success] = "Member with #{email} is invited!"
        redirect_to tenant_members_path(@current_tenant)

    end

    private

    def set_current_tenant
        @current_tenant = Tenant.find(params[:tenant_id])        
    end

end
