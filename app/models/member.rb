class Member < ApplicationRecord
  belongs_to :user
  belongs_to :tenant

  has_many :boards
end
