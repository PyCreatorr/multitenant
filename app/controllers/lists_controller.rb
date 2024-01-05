class ListsController < ApplicationController
  before_action :set_list, only: %i[ show edit update destroy ]

  include ActionView::RecordIdentifier # include dom_id method identifier

  # GET /lists or /lists.json
  def index
    # @lists = List.all
    @lists = List.where(board_id: params[:board_id]).rank(:row_order)
    # @lists = List.all
    # @lists = List.sorted
  end

  def sort
    @list = List.find(params[:id])
    respond_to do |format|
      if @list.update(row_order_position: params[:row_order_position])
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
        @update_list = dom_id(@list, :sortable)
        # debugger
        #format.turbo_stream { render turbo_stream: turbo_stream.update(dom_id(@list, :sortable))}
        format.turbo_stream { render "update_list", 
          locals: { list: @list, update_list: @update_list  }
        }        
        # format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@scan, :uploaded_image))}

      end
    end
  end

  # GET /lists/1 or /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
    positions = []
    i = 0
    List.where(board_id: @list.board_id).rank(:row_order).each do |list|
      positions[i]=[list.row_order, i+1]
      i=i+1      
    end
    @positions = positions

    #debugger
  end

  # POST /lists or /lists.json
  def create
    # debugger
    @list = List.new(name: params[:name], board_id: params[:board_id])

    respond_to do |format|
      if @list.save

        
        @board = Board.find(@list.board_id)

        format.turbo_stream { render "lists/update_lists", 
          locals: { board: @board, list: @list, position: 0  }
        }
        
        # format.turbo_stream { render "prepend_list", 
        #   locals: { list: @list }
        # }

        format.html { redirect_to "/boards/#{@list.board_id}", notice: "List was successfully created." }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1 or /lists/1.json
  def update

    positions = []
    i = 0
    List.where(board_id: @list.board_id).rank(:row_order).each do |list|
      positions[i]=[list.row_order, i+1]
      i=i+1      
    end
    @positions = positions
    
    pos_current = 0;
    pos_new = 0;
    pos_new_more = 0;

    r_order_new = -1;
    r_order_current = -1;
    r_order_new_more = -1;

    # debugger
    
    # Get current position number & current row order
    pos_current = @positions.find { |el| el[0].to_s == @list.row_order.to_s }[1] if @list 
    r_order_current = @positions.find { |el| el[0].to_s == @list.row_order.to_s }[0] if @list 

    # Get the row order selected new position
    if @positions.find { |el| el[0].to_s == params[:list][:row_order] }[1]      
      pos_new = @positions.find { |el| el[0].to_s == params[:list][:row_order] }[1]      
      r_order_new = @positions.find { |el| el[0].to_s == params[:list][:row_order] }[0]      
    end     
    
    pos_current = 0 if pos_current == nil
    
    # If the new position is greater then the old position, but not the last position
    if (pos_new > pos_current) && (pos_new < @positions.length)
      pos_new_more = pos_new + 1 
      r_order_new_more = @positions.find { |el| el[1] == pos_new_more }[0]

      min_l = r_order_new + 1
      max_l = r_order_new_more - 1
      params[:list][:row_order] = (rand(min_l..max_l)).to_s 

    # If the new position is greater then the old position and the last position
    elsif (pos_new > pos_current) && (pos_new == @positions.length)      
      r_order_new_more = r_order_new + 1

      min_l = r_order_new + 1
      max_l = r_order_new_more - 1
      params[:list][:row_order] = (rand(min_l..max_l)).to_s 
    end

    # If we've choose smaller position than the current
    params[:list][:row_order] = (r_order_new - 1).to_s if pos_new < pos_current

    # debugger
    

    respond_to do |format|      

      if @list.update(list_params)

        # debugger

        @update_list = dom_id(@list, :sortable)
        @board = Board.find(@list.board_id)

        format.turbo_stream { render "update_lists", 
          locals: { board: @board, list: @list, position: pos_new }
        }

        # format.turbo_stream { render "update_list", 
        #   locals: { list: @list, update_list: @update_list  }
        # }

        format.html { redirect_to "/boards/#{@list.board_id}", notice: "List was successfully updated." }
        # format.json { render :show, status: :ok, location: @list }
        format.json { render json: { status: 'ok', name: @list.name } }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1 or /lists/1.json
  def destroy
    @list.destroy
    @update_list = dom_id(@list, :sortable)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@update_list) }
      format.html { redirect_to lists_url, notice: "List was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
      rescue ActiveRecord::RecordNotFound        
        redirect_to tenants_path
        flash[:danger] = "This List with id = #{params[:id]} doesnt exsists!"
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.require(:list).permit(:name, :row_order, :positions)
    end
end
