class MembersController < ApplicationController
    before_action :set_current_tenant, only: [:index]
    def index
        #@members = Member.find(params[:tenant_id].
        @members = @current_tenant.members
    end

    private

    def set_current_tenant
        @current_tenant = Tenant.find(params[:tenant_id])        
    end

end
