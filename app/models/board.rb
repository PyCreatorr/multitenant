class Board < ApplicationRecord
  validates :name, presence: true
  
  belongs_to :member
  belongs_to :tenant

  has_many :lists, dependent: :destroy
  # has_many :tasks

end
