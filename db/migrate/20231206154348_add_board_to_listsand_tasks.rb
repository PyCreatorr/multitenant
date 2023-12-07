class AddBoardToListsandTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :lists, :board, null: false, foreign_key: true
    add_reference :tasks, :board, null: false, foreign_key: true
  end
end
