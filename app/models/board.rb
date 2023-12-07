class Board < ApplicationRecord
  validates :name, presence: true
  
  belongs_to :member
  belongs_to :tenant

  has_many :lists
  # has_many :tasks

end
