class AddTrackedItemToPieces < ActiveRecord::Migration[6.1]
  def change
    add_reference :pieces, :tracked_item, null: false, foreign_key: true
  end
end
