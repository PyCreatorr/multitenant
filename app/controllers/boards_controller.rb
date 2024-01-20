class BoardsController < ApplicationController
  before_action :set_board, only: %i[ show edit update destroy ]
  before_action :set_boards_member, only: [:show]

  # GET /boards or /boards.json
  def index
    
    @boards = Board.all.where(tenant_id: params[:tenant_id])
  end


  def select_all
    #@members = Member.find(params[:tenant_id].

    @boards = Board.all.where(tenant_id: params[:tenant_id])
    
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
    
    @board = Board.new(name: params[:name], tenant_id: params[:tenant_id], member_id: member.id)

    respond_to do |format|
      if @board.save
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
    # debugger
    respond_to do |format|
      #if @board.update(name: params[:name], tenant_it: params[:tenant_id], member_id: params[:member_id])
      if @board.update(board_params)
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

      @all_boards = Board.where(tenant_id: @current_tenant_id)
      @current_user_member = current_user.members.where(tenant_id: @current_tenant_id).first

      rescue ActiveRecord::RecordNotFound
        redirect_to root_path
        flash[:danger] = "This board does not exist!"
    end

    # Only allow a list of trusted parameters through.
    def board_params
      params.require(:board).permit(:name, :member_id, :tenant_id)
      # params.permit(:name, :member_id, :tenant_id)
    end
end
