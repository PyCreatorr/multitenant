class Task < ApplicationRecord
  validates :name, presence: true
  belongs_to :list
  # belongs_to :board

  include RankedModel
  ranks :row_order, with_same: :list_id
end
