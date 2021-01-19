class Piece < ApplicationRecord
  validates :name, presence: true
  validates :frequency_time, presence: true, numericality: { only_integer: true }
  validates :frequency, presence: true, numericality: { only_integer: true }

  belongs_to :tracked_item

  has_many :taken_times, dependent: :destroy
end
