class Tenant < ApplicationRecord
    validates :name, presence: true


    has_many :members, dependent: :destroy
    has_many :users, through: :members

    has_many :boards, dependent: :destroy
    
end
