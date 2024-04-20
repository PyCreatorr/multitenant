class BoardsController < ApplicationController
  before_action :set_board, only: %i[ show edit update destroy ]
  before_action :set_boards_member, only: [:show, :update]

  include ActionView::RecordIdentifier # include dom_id method identifier

  # GET /boards or /boards.json
  def index    
    # @boards = Board.all.where(tenant_id: params[:tenant_id]).rank(:row_order)
    @boards = Board.all.where(tenant_id: params[:tenant_id]).rank(:row_order)
  end

  def sort
    @board = Board.find(params[:id])
    respond_to do |format|
      if @board.update(row_order_position: params[:row_order_position])
        # debugger

        format.html {
          headers["www-Authenticate"] = root_url
          # head :unauthorized
          head :no_content
        }
        # format.turbo_stream{ head :no_content }
        # format.turbo_stream { render "users/new_friend", 
        #   locals: { friend: "", allowed: false,  flash_notice: "The friend #{params[:full_name]} #{params[:email]} is already trackt!" }
        # }
        @update_board = dom_id(@board, :sortable)
        # debugger
        #format.turbo_stream { render turbo_stream: turbo_stream.update(dom_id(@list, :sortable))}
        format.turbo_stream { render "update_board", 
          locals: { board: @board, update_board: @update_board  }
        }        
        # format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@scan, :uploaded_image))}

      end
    end
  end


  def select_all
    #@members = Member.find(params[:tenant_id].

    @boards = Board.all.where(tenant_id: params[:tenant_id]).rank(:row_order)
    
    # @members = @current_tenant.members

    # debugger 
    respond_to do |format|
        
        format.turbo_stream  { render partial: "boards/boards_all", 
            locals: { boards: @boards  }
        }
        # format.html { render :index }

    end
  end


  # GET /boards/1 or /boards/1.json
  def show

    # debugger

    @current_user_boards = Board.where(member_id: @current_user_member.id, tenant_id: @current_tenant_id) if @current_user_member.present?

    if !@current_user_member.present?
      redirect_to tenants_path
      flash[:danger] = "The board does not exist! Check your boards here"

    end
 
    
    #current_board = Board.find(params[:id])
    # @current_tenant_id = @board.tenant_id

    # @all_boards = Board.where(tenant_id: @current_tenant_id)

    # @current_user_member = current_user.members.where(tenant_id: @current_tenant_id).first

    # @current_user_boards = Board.where(member_id: @current_user_member.id, tenant_id: @current_tenant_id)

    # debugger

  end

  # GET /boards/new
  def new
    @board = Board.new
    @tenant = params[:tenant_id]
    # @member = Member.find_by(user_id: current_user.id)
    #@tenant = Tenant.new

    # debugger

  end

  # GET /boards/1/edit
  def edit

    positions = []
    i = 0
    Board.where(tenant_id: @board.tenant_id).rank(:row_order).each do |board|
      positions[i]=[board.row_order, i+1]
      i=i+1      
    end
    
    @positions = positions

  end

  # POST /boards or /boards.json
  def create
    member = Member.find_by(user_id: current_user.id, tenant_id: params[:tenant_id])

    # debugger
    if !member.present?
      redirect_to root_path
      flash[:danger] = "You are not permitted to create a boards!"
    end
    # rescue ActiveRecord::RecordNotFound
    #   redirect_to root_path
    #   flash[:danger] = "You are not permitted to create a boards!"
    
    @board = Board.new(name: params[:name], tenant_id: params[:tenant_id], member_id: member.id, font_color: params[:font_color], bg_color: params[:bg_color])
    @tenant = Tenant.find(params[:tenant_id])
    
    
    respond_to do |format|
      if @board.save

        @update_tenant = "tenant_#{params[:tenant_id]}"

        format.turbo_stream { render "add_board", 
          locals: { board: @board, tenant: @tenant, update_tenant: @update_tenant }
        }

        # format.turbo_stream { render "lists/update_lists", 
        #   locals: { board: @board, list: @list, position: 0  }
        # }

        format.html { redirect_to board_url(@board), notice: "Board was successfully created." }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boards/1 or /boards/1.json
  def update

    @current_user_boards = Board.where(member_id: @current_user_member.id, tenant_id: @current_tenant_id) if @current_user_member.present?
    if !@current_user_member.present?
      redirect_to tenants_path
      flash[:danger] = "The board does not exist! Check your boards here"

    end

    # Get the actual positions array of the boards in the tenant
    positions = []
    i = 0
    Board.where(tenant_id: @board.tenant_id).rank(:row_order).each do |board|
      positions[i]=[board.row_order, i+1]
      i=i+1      
    end
    
    @positions = positions

    sort_positions(@positions, @board, :board)
    
    # #### SORT LOGIC #################

    # pos_current = 0;
    # pos_new = 0;
    # pos_new_more = 0;

    # r_order_new = -1;
    # r_order_current = -1;
    # r_order_new_more = -1;

    # # debugger

    # # Get current position number & current row order
    # pos_current = @positions.find { |el| el[0].to_s == @board.row_order.to_s }[1] if @board 
    # r_order_current = @positions.find { |el| el[0].to_s == @board.row_order.to_s }[0] if @board 

    # # Get the row order selected new position
    # if @positions.find { |el| el[0].to_s == params[:board][:row_order] }[1]      
    #   pos_new = @positions.find { |el| el[0].to_s == params[:board][:row_order] }[1]      
    #   r_order_new = @positions.find { |el| el[0].to_s == params[:board][:row_order] }[0]      
    # end     
    
    # pos_current = 0 if pos_current == nil
    
    # # If the new position is greater then the old position, but not the last position
    # if (pos_new > pos_current) && (pos_new < @positions.length)
    #   pos_new_more = pos_new + 1 
    #   r_order_new_more = @positions.find { |el| el[1] == pos_new_more }[0]

    #   min_l = r_order_new + 1
    #   max_l = r_order_new_more - 1
    #   params[:board][:row_order] = (rand(min_l..max_l)).to_s 

    # # If the new position is greater then the old position and the last position
    # elsif (pos_new > pos_current) && (pos_new == @positions.length)      
    #   r_order_new_more = r_order_new + 1

    #   min_l = r_order_new + 1
    #   max_l = r_order_new_more - 1
    #   params[:board][:row_order] = (rand(min_l..max_l)).to_s 
    # end

    # # If we've choose smaller position than the current
    # params[:board][:row_order] = (r_order_new - 1).to_s if pos_new < pos_current

    # ######## END #####

    # debugger
    respond_to do |format|

      @update_board = dom_id(@board) 

      #if @board.update(name: params[:name], tenant_it: params[:tenant_id], member_id: params[:member_id])
      if @board.update(board_params)

        format.turbo_stream { render "update_board", 
          locals: { board: @board, update_board: @update_board  }
        }


        format.html { redirect_to board_url(@board), notice: "Board was successfully updated." }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1 or /boards/1.json
  # `/tenants/#{@board.tenant_id}`
  def destroy
    @board.destroy

    respond_to do |format|
      format.html { redirect_to tenant_path(@board.tenant_id), notice: "Board was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to root_path
        flash[:danger] = "This board does not exist!"
    end

    def set_boards_member
      @board = Board.find(params[:id])

      @current_tenant_id = @board.tenant_id
      @current_tenant = Tenant.find(@current_tenant_id)

      @all_boards = Board.where(tenant_id: @current_tenant_id)
      @current_user_member = current_user.members.where(tenant_id: @current_tenant_id).first

      rescue ActiveRecord::RecordNotFound
        redirect_to root_path
        flash[:danger] = "This board does not exist!"
    end

    # Only allow a list of trusted parameters through.
    def board_params
      params.require(:board).permit(:name, :member_id, :tenant_id, :font_color, :bg_color, :row_order, :positions)
      # params.permit(:name, :member_id, :tenant_id)
    end
end
