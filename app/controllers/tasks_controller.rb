class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  include ActionView::RecordIdentifier # include dom_id method identifier

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all
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

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(name: params[:name], list_id: params[:list_id])

    respond_to do |format|
      if @task.save
        board = List.find(params[:list_id]).board_id
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
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
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
      params.require(:task).permit(:name, :list_id)
    end
end
