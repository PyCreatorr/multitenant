class Task < ApplicationRecord

  # Action text migration
  has_one_attached :cover_image
  has_rich_text :description

  validates :name, presence: true  

  # validate :attachments_size
  
  belongs_to :list
  # belongs_to :board

  include RankedModel
  ranks :row_order, with_same: :list_id

  # private

  # def attachments_size
    
  #     # debugger
  #     if cover_image.attached? && cover_image.blob.byte_size > 1.megabytes
  #       # flash[:danger] = "One or more files are too large. Please upload files smaller than 1 MB each."
  #       # return redirect_to root_path
  #      errors.add(:cover_image, "One or more files are too large. Please upload files smaller than 1 MB each.")

  #     end
  # end

end
