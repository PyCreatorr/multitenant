class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy]

  include ActionView::RecordIdentifier # include dom_id method identifier

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all
  end

  def search
    #binding.break
    #render json: params[:friend]
    #binding.break 
    #debugger   

    if !params[:friend].empty?

      # @stock = Stock.new_lookup(params[:stock])
      # strip! - removes empty signs
      @friends = User.find_friends(params[:friend])      
      
      if @friends
          # exclude current user from the friends list
          @friends = current_user.except_current_user(@friends)

              respond_to do |format|
                  format.turbo_stream { render "users/create_friends"}
              end
             
          
      else 
              flash.now[:danger] = "Please enter a valid symbol to search"
              # redirect_to my_data_path
              respond_to do |format|
                  format.turbo_stream { render "users/create_friends"}
              end
              #binding.break
              # render json: @stock
      end
          

    else 
              flash.now[:alert] = "You need to place a symbol!"
              respond_to do |format|
                  format.turbo_stream { render "users/create_friends"}
              end
    end
              # redirect_to my_data_path

  end

  def sort
    @task = Task.find(params[:id])
    # debugger
    respond_to do |format|
      if @task.update(row_order_position: params[:row_order_position], list_id: params[:list_id])

        format.html {
          # headers["www-Authenticate"] = root_url
          # head :unauthorized
          head :no_content
        }
        # format.turbo_stream{ head :no_content }    
        
        @update_task = dom_id(@task, :sortable)
        # debugger
        #format.turbo_stream { render turbo_stream: turbo_stream.update(dom_id(@list, :sortable))}
        format.turbo_stream { render "update_task", 
          locals: { task: @task, update_task: @update_task  }
        }

      end
    end
  end

  def selected_list
      # GET THE POSITIONS IN THE CURRENT LIST

      @selected_list = List.find(params[:selected_list])
      positions = []
      i = 0      

      Task.where(list_id: @selected_list.id).rank(:row_order).each do |task|
        positions[i]=[i+1, task.row_order]
        i=i+1      
      end
      @positions = positions
      @target = params[:target]

      # debugger

      # if Task.find(params[:id]).present
      #   @task = Task.find(params[:id]) 
      # else 
      #   @task = Task.new(name: params[:name], list_id: params[:list_id], row_order: (@positions[i][1].to_i+1).to_s)
      # end

      respond_to do |format|

        format.turbo_stream 
        # format.turbo_stream { render "update_task", 
        #   locals: { task: @task, update_task: @update_task  }
        # }
        # format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
        # format.json { head :no_content }
      end
  end

  def selected_board
    @selected_board = Board.find(params[:selected_board])
    selected_board_lists = []
    i = 0
    List.where(board_id: params[:selected_board]).rank(:row_order).each do |list|
      selected_board_lists[i]=[list.name, list.id]
      i=i+1      
    end

    @selected_board_lists = selected_board_lists

    positions = []
    i = 0      
    if @selected_board_lists.length != 0
    
      Task.where(list_id: @selected_board_lists[0][1]).rank(:row_order).each do |task|
        positions[i]=[i+1, task.row_order]
        i=i+1      
      end
    else # @selected_board_lists = [["No Lists",0]]
    end
    @positions = positions

     @positions = [] if @positions.length == 0


    @target = params[:target]
    @tasks_target = params[:tasks_target]
    
    respond_to do |format|

      format.turbo_stream 
      # format.turbo_stream { render "update_task", 
      #   locals: { task: @task, update_task: @update_task  }
      # }
      # format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      # format.json { head :no_content }
    end


  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  # GET the lists, to which belongs the current task
    selected_board_lists = []
    list_boards = []
    i = 0
    @cur_list = List.find(@task.list_id)
    @cur_board_id = @cur_list.board_id
    @cur_tenant_id = Board.find(@cur_board_id).tenant_id

    List.where(board_id: @cur_board_id).rank(:row_order).each do |list|
      selected_board_lists[i]=[list.id, list.name]
      i=i+1      
    end

    @selected_board_lists = selected_board_lists

    # Get the boards, which are belogs to the current tenant
    i = 0    
    Board.where(tenant_id: @cur_tenant_id).each do |board|
      list_boards[i]=[board.id, board.name]
      i=i+1      
    end

    @list_boards = list_boards

    # GET THE POSITIONS IN THE CURRENT LIST
    positions = []
    i = 0
    Task.where(list_id: @task.list_id).rank(:row_order).each do |list|
      positions[i]=[list.row_order, i+1]
      i=i+1      
    end
    @positions = positions

  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(name: params[:name], list_id: params[:list_id], description: params[:description] )

    # debugger

    respond_to do |format|
      if @task.save
        board = List.find(params[:list_id]).board_id

        tasks_add_new = "tasks_add_new_#{params[:list_id]}"

        # format.turbo_stream { render "prepend_task", 
        #   locals: { tasks_add_new: tasks_add_new, task: @task }
        # }

        @list_2_update = "sortable_list_#{ @task.list_id }"

        @list = List.find(@task.list_id)
        @board = Board.find(@list.board_id)

        format.turbo_stream { render "lists/update_list", 
          locals: { board: @board, list: @list, list_2_update: @list_2_update, position: 0  }
        }

        format.html { redirect_to "/boards/#{board}", notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update

    # GET THE POSITIONS IN THE CURRENT LIST
    positions = []
    i = 0
    Task.where(list_id: params[:task][:list_id].present? ? params[:task][:list_id] : @task.list_id).rank(:row_order).each do |task|
      positions[i]=[task.row_order, i+1]
      i=i+1      
    end
    @positions = positions

    pos_current = nil;
    pos_new = 0;
    pos_new_more = 0;

    r_order_new = nil;
    r_order_current = nil;
    r_order_new_more = nil;
    
 
    
    # CASE 1: Same board, same list change the task position in the same list. 
    # Array @positions includes the current & the new row_orders
    # Check if it is the same boards
    # Check if it is the same lists
    cur_list_id = @task.list_id
    cur_board_id = List.find(@task.list_id).board_id

    new_list_id = params[:task][:list_id].to_i if params[:task][:list_id].present?
    new_board_id = params[:task][:board_id].to_i if params[:task][:board_id].present?

    if cur_board_id == new_board_id

      # CASE 1: Same board, same list change the task position in the same list.
      if cur_list_id == new_list_id

        pos_current = @positions.find { |el| el[0].to_s == @task.row_order.to_s}[1] if @task 
        r_order_current = @task.row_order 
        
        pos_new = @positions.find { |el| el[0].to_s == params[:task][:row_order] }[1]      
        r_order_new = @positions.find { |el| el[0].to_s == params[:task][:row_order] }[0]

        # debugger

        # If the new position is greater then the old position, but not the last position
        if pos_current && pos_new > pos_current && pos_new < @positions.length
          pos_new_more = pos_new + 1 
          
          r_order_new_more = @positions.find { |el| el[1] == pos_new_more }[0]

          min_l = r_order_new
          max_l = r_order_new_more

          # min_l = min_l -1 if min_l < 0
          # max_l = max_l -1 if max_l < 0

          # params[:task][:row_order] = rand(min_l..max_l).to_s

          params[:task][:row_order] = max_l.to_s

        # If the new position is greater then the old position and the last position
        elsif (pos_new > pos_current) && (pos_new == @positions.length)      
          r_order_new_more = r_order_new + 1
          min_l = r_order_new +1
          max_l = r_order_new_more + 1
          params[:task][:row_order] = (rand(min_l..max_l)).to_s 
        
        # If we've choose smaller position than the current
        elsif (pos_new < pos_current)

          # debugger
          params[:task][:row_order] = (r_order_new).to_s
        end
        params[:task][:row_order] = 0 if !pos_current && @positions.length == 0       
      
      # CASE 2: Same board, different lists
      else
        pos_2paste = @positions.find { |el| el[0].to_s == params[:task][:row_order].to_s}[1] if params[:task][:row_order].present?
        r_order_2paste = @positions.find { |el| el[0].to_s == params[:task][:row_order]}[0] if params[:task][:row_order].present?

        # if it is the first position to paste
        params[:task][:row_order] = r_order_2paste -1 if pos_2paste == 1

        #if it is the last position to paste
      #if it is the last position to paste
      params[:task][:row_order] = r_order_2paste +1 if params[:task][:row_order].present? && pos_2paste == @positions.length && @positions.length != 1
        
        # If it is the middle position. 
        if pos_2paste.present? && pos_2paste != 1 && pos_2paste != @positions.length && @positions.length > 2
          pos_2paste_next = pos_2paste + 1
          r_order_next = @positions.find { |el| el[1] == pos_2paste_next }[0]

          min_l = r_order_2paste
          max_l = r_order_next          
          params[:task][:row_order] = min_l.to_s
        end

        params[:task][:row_order] = 0 if !pos_2paste.present?
      
      end
    # CASE 3: different boards
    else 

      # debugger
      
      pos_2paste = @positions.find { |el| el[0].to_s == params[:task][:row_order].to_s}[1] if params[:task][:row_order].present?
      r_order_2paste = @positions.find { |el| el[0].to_s == params[:task][:row_order]}[0] if params[:task][:row_order].present?
      
      # if it is the first position to paste
      params[:task][:row_order] = r_order_2paste -1 if params[:task][:row_order].present? && pos_2paste == 1

      #if it is the last position to paste
      params[:task][:row_order] = r_order_2paste +1 if params[:task][:row_order].present? && pos_2paste == @positions.length && @positions.length != 1
      
      # If it is the middle position. 
      if pos_2paste.present? && pos_2paste != 1 && pos_2paste != @positions.length && @positions.length > 2
        pos_2paste_next = pos_2paste + 1
        r_order_next = @positions.find { |el| el[1] == pos_2paste_next }[0]

        min_l = r_order_2paste
        max_l = r_order_next          
        params[:task][:row_order] = min_l.to_s
      end

      params[:task][:row_order] = 0 if !pos_2paste.present?

    end

    old_list = @task.list_id
    new_list = params[:task][:list_id]

    old_task_order = @task.row_order
    new_task_order = params[:task][:row_order] if params[:task][:row_order].present?
    
    
    respond_to do |format|
     
      @update_task = dom_id(@task, :sortable) 

      # debugger

      # if params[:task][:row_order] 
        if @task.update(name: params[:task][:name], list_id: params[:task][:list_id].present? ? params[:task][:list_id] : @task.list_id, row_order: params[:task][:row_order].present? ? params[:task][:row_order] : @task.row_order, description: params[:task][:description] )
          #board = List.find(params[:list_id]).board_id           

          if (old_list == new_list.to_i) && (old_task_order == new_task_order)
            format.turbo_stream { render "update_task", 
              locals: { task: @task, update_task: @update_task  }
            }
          elsif (old_list != new_list.to_i) || (old_task_order != new_task_order)
            # debugger

            @list = List.find(@task.list_id)
            @board = Board.find(@list.board_id)

            format.turbo_stream { render "lists/update_lists", 
              locals: { board: @board, list: @list, position: 0  }
            }
          end

          format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
          # format.json { render :show, status: :ok, location: @task }
          format.json { render json: { status: 'ok', name: @task.name } }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end

      # elsif @task.update(name: params[:task][:name], list_id: @task.list_id, row_order: @task.row_order)
      #       format.turbo_stream { render "update_task", 
      #         locals: { task: @task, update_task: @update_task  }
      #       }      
      # else
      #   format.html { render :edit, status: :unprocessable_entity }
      #   format.json { render json: @task.errors, status: :unprocessable_entity }
      # end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    
    @update_task = dom_id(@task, :sortable)
    @task.destroy

    # render turbo_stream: turbo_stream.remove(dom_id(@scan, :uploaded_image))
    
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@update_task) }
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:name, :list_id, :list_boards, :selected_board_lists, :row_order, :board_id, :description, :cover_image)
    end
end
