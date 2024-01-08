class Task < ApplicationRecord

  # Action text migration
  has_one_attached :cover_image
  has_rich_text :description

  validates :name, presence: true  
  belongs_to :list
  # belongs_to :board

  include RankedModel
  ranks :row_order, with_same: :list_id
end
