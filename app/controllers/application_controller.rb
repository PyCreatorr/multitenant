class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    # Refactoring function. Params example: sort_positions(positions_array, @list, :list)
    #  positions_array =  [5516554,1],[3628736,2],[598759847,3] = [:row_order, position in the array]
    #  See docs about row_order here: https://github.com/brendon/ranked-model

    def sort_positions(positions, model2sort, model_param)
        #### SORT LOGIC #################

        pos_current = 0;
        pos_new = 0;
        pos_new_more = 0;

        r_order_new = -1;
        r_order_current = -1;
        r_order_new_more = -1;

        # debugger

        # Get current position number & current row order
        pos_current = positions.find { |el| el[0].to_s == model2sort.row_order.to_s }[1] if model2sort 
        r_order_current = positions.find { |el| el[0].to_s == model2sort.row_order.to_s }[0] if model2sort 

        # Get the row order selected new position
        if positions.find { |el| el[0].to_s == params[model_param][:row_order] }[1]      
            pos_new = positions.find { |el| el[0].to_s == params[model_param][:row_order] }[1]      
            r_order_new = positions.find { |el| el[0].to_s == params[model_param][:row_order] }[0]      
        end     
        
        pos_current = 0 if pos_current == nil
        
        # If the new position is greater then the old position, but not the last position
        if (pos_new > pos_current) && (pos_new < positions.length)
            pos_new_more = pos_new + 1 
            r_order_new_more = positions.find { |el| el[1] == pos_new_more }[0]

            min_l = r_order_new + 1
            max_l = r_order_new_more - 1
            params[model_param][:row_order] = (rand(min_l..max_l)).to_s 

        # If the new position is greater then the old position and the last position
        elsif (pos_new > pos_current) && (pos_new == positions.length)      
            r_order_new_more = r_order_new + 1

            min_l = r_order_new + 1
            max_l = r_order_new_more - 1
            params[model_param][:row_order] = (rand(min_l..max_l)).to_s 
        end

        # If we've choose smaller position than the current
        params[model_param][:row_order] = (r_order_new - 1).to_s if pos_new < pos_current

        return pos_new
    end
end
