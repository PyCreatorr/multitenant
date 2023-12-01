class AuthorizedController < ApplicationController
    before_action :set_current_tenant
    before_action :authorize_member


    private

    def set_current_tenant
        @current_tenant = Tenant.find(params[:tenant_id])        
    end

    def authorize_member
        unless @current_tenant.users.include?(current_user)
          flash[:danger] = "You are not a member"
          return redirect_to root_path
        end
    end

end