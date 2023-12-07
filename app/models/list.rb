class List < ApplicationRecord
    validates :name, presence: true
    has_many :tasks
    belongs_to :board

    # scope :sorted, -> { order(Arel.sql("created_at DESC NULLS FIRST")).order(updated_at: :desc) }
    # scope :sorted, -> { order(Arel.sql("row_order ASC NULLS FIRST")) }
    # scope :sorted, -> { order(Arel.sql("row_order ASC NULLS FIRST")).order(updated_at: :asc)  }

    include RankedModel
    ranks :row_order, with_same: :board_id
   
end
