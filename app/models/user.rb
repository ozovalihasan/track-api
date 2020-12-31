class User < ApplicationRecord
  has_secure_password

  validates :username, uniqueness: { case_sensitive: true }, presence: true

  has_many :tracked_items, dependent: :destroy
end
