class TakenTime < ApplicationRecord
  belongs_to :piece

  def as_json(options={})

    {
        :id => self.id,
        :created_at => self.created_at.to_time.to_i,
        :updated_at => self.updated_at.to_time.to_i,
        :piece => {id: self.piece.id, name: self.piece.name},
        :tracked_item_id => self.piece.tracked_item.id
    }

  end

end
