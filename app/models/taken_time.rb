class TakenTime < ApplicationRecord
  belongs_to :piece

  def as_json(_options = {})
    {
      id: id,
      created_at: created_at.to_time.to_i,
      updated_at: updated_at.to_time.to_i,
      piece: { id: piece.id, name: piece.name },
      tracked_item_id: piece.tracked_item.id
    }
  end
end
