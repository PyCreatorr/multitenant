class AddRowOrderToBoards < ActiveRecord::Migration[7.0]
  def change
    add_column :boards, :row_order, :integer
  end
end
