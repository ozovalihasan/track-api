class TrackedItemsController < ApplicationController
  before_action :set_tracked_item, only: %i[show update destroy]
  before_action :authorized

  def index
    @tracked_items = TrackedItem.where(user_id: @user.id)

    render json: @tracked_items
  end

  def show
    @pieces = @tracked_item.pieces
    render json: { tracked_item: @tracked_item, pieces: @pieces }
  end

  def create
    @tracked_item = @user.tracked_items.new(tracked_item_params)

    if @tracked_item.save
      render json: @tracked_item, status: :created, location: @tracked_item
    else
      render json: @tracked_item.errors, status: :unprocessable_entity
    end
  end

  def update
    if @tracked_item.update(tracked_item_params)
      render json: @tracked_item
    else
      render json: @tracked_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @tracked_item.destroy
  end

  private

  def set_tracked_item
    @tracked_item = TrackedItem.find(params[:id])
  end

  def tracked_item_params
    params.require(:tracked_item).permit(:name)
  end
end
