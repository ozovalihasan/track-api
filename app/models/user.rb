class User < ApplicationRecord
  has_secure_password

  validates :username, uniqueness: { case_sensitive: true }, presence: true

  has_many :tracked_items, dependent: :destroy
  has_many :pieces, through: :tracked_items
  has_many :taken_times, through: :pieces
end
