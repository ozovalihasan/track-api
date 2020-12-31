class CreateTakenTimes < ActiveRecord::Migration[6.1]
  def change
    create_table :taken_times do |t|
      t.references :piece, null: false, foreign_key: true

      t.timestamps
    end
  end
end
