class CreatePieces < ActiveRecord::Migration[6.1]
  def change
    create_table :pieces do |t|
      t.string :name
      t.integer :frequency_time
      t.integer :frequency
      t.integer :percentage

      t.references :tracked_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
