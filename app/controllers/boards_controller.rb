class BoardsController < ApplicationController
  before_action :set_board, only: %i[ show edit update destroy ]

  # GET /boards or /boards.json
  def index
    @boards = Board.all
  end

  # GET /boards/1 or /boards/1.json
  def show
     # debugger
    current_board = Board.find(params[:id])
    current_tenant_id = current_board.tenant_id

    current_member = Member.find(current_board.member_id)
    # @all_boards = Board.where(member_id: current_member.id, tenant_id: current_tenant_id)
    @all_boards = Board.where(tenant_id: current_tenant_id)

  end

  # GET /boards/new
  def new
    @board = Board.new
    @tenant = params[:tenant_id]
    # @member = params[:member_id]
    #@tenant = Tenant.new

    # debugger

  end

  # GET /boards/1/edit
  def edit
  end

  # POST /boards or /boards.json
  def create
    #debugger
    member = Member.find_by(user_id: current_user.id)
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

    # Only allow a list of trusted parameters through.
    def board_params
      params.require(:board).permit(:name, :member_id, :tenant_id)
      # params.permit(:name, :member_id, :tenant_id)
    end
end
