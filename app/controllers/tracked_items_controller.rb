class TrackedItemsController < ApplicationController
  before_action :set_tracked_item, only: %i[show update destroy]
  before_action :authorized

  # GET /tracked_items
  def index
    @tracked_items = TrackedItem.where(user_id: @user.id)

    render json: @tracked_items
  end

  # GET /tracked_items/1
  def show
    render json: @tracked_item
  end

  # POST /tracked_items
  def create
    @tracked_item = TrackedItem.new(tracked_item_params)
    @tracked_item.user_id = @user.id

    if @tracked_item.save
      render json: @tracked_item, status: :created, location: @tracked_item
    else
      render json: @tracked_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tracked_items/1
  def update
    if @tracked_item.update(tracked_item_params)
      render json: @tracked_item
    else
      render json: @tracked_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tracked_items/1
  def destroy
    @tracked_item.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tracked_item
    @tracked_item = TrackedItem.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def tracked_item_params
    params.require(:tracked_item).permit(:message, :user_id)
  end
end
