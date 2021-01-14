class TakenTimesController < ApplicationController
  before_action :set_taken_time, only: %i[destroy]
  before_action :authorized
  before_action :check_own, only: %i[destroy]
  before_action :set_piece, only: %i[create]

  # GET /taken_times
  def index
    @taken_times = @user.taken_times.includes(:piece).order(created_at: :desc)

    render json: @taken_times
  end

  # POST /taken_times
  def create
    @taken_time = @piece.taken_times.new

    if @taken_time.save
      render json: @taken_time, status: :created, location: @taken_time
    else
      render json: @taken_time.errors, status: :unprocessable_entity
    end
  end

  # DELETE /taken_times/1
  def destroy
    @taken_time.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_taken_time
    @taken_time = TakenTime.find(params[:id])
  end

  def set_piece
    @piece = Piece.find(params[:piece_id])

    return if @piece.tracked_item.user.id == @user.id

    render json: { message: 'You are not authorized to receive this record' }, status: :unauthorized
  end

  def check_own
    return if TakenTime.find(params[:id]).piece.tracked_item.user.id == @user.id

    render json: { message: 'You are not authorized to receive this record' }, status: :unauthorized
  end
end
