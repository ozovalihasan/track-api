class PiecesController < ApplicationController
  before_action :set_piece, only: %i[show update destroy]
  before_action :authorized
  before_action :check_own, only: %i[show update destroy]
  before_action :set_tracked_item, only: ['create']

  # GET /pieces
  def index
    @pieces = Piece.joins(:tracked_item).where(tracked_item: { user_id: @user.id }).order(created_at: :desc)

    render json: @pieces
  end

  # GET /pieces/1
  def show
    @taken_times = @piece.taken_times
    render json: { piece: @piece, taken_times: @taken_times }
  end

  # POST /pieces
  def create
    @piece = @tracked_item.pieces.new(piece_params)

    if @piece.save
      render json: @piece, status: :created, location: @piece
    else
      render json: @piece.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pieces/1
  def update
    if @piece.update(piece_params)
      render json: @piece
    else
      render json: @piece.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pieces/1
  def destroy
    @piece.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_piece
    @piece = Piece.find(params[:id])
  end

  def set_tracked_item
    @tracked_item = TrackedItem.find(params[:tracked_item_id])
    return if @tracked_item.user.id == @user.id

    render json: { message: 'You are not authorized to receive this record' }, status: :unauthorized
  end

  def check_own
    return if Piece.find(params[:id]).tracked_item.user.id == @user.id

    render json: { message: 'You are not authorized to receive this record' }, status: :unauthorized
  end

  # Only allow a trusted parameter "white list" through.
  def piece_params
    params.require(:piece).permit(:name, :frequency_time, :frequency, :percentage)
  end
end
