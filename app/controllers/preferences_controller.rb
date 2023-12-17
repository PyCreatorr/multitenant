class PreferencesController < ApplicationController
    def sidebar_position
        #@preferences = Preference.find(params[:sidebar_position])
        # debugger
        # if user_signed_in? && !key.nil?
            if current_user.preference.present? && params[:sidebar_position].present?
                Preference.update(sidebar_position: params[:sidebar_position], user_id: current_user.id)
            
            elsif !current_user.preference && params[:sidebar_position].present?

                preferences = { sidebar_position: params[:sidebar_position], user_id: current_user.id }
                current_user_preference = Preference.create(**preferences)
                current_user_preference.save          
                # return current_user.preference[sidebar_position]           
            end
    end

    # def get
    #     @preferences = current_user.preference

    # end
end
