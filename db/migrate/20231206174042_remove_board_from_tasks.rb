class RemoveBoardFromTasks < ActiveRecord::Migration[7.0]
  def change
    remove_reference :tasks, :board, null: false, foreign_key: true
  end

  # remove_column :tasks, :board_id
  # def up
  #   change_table :tasks do |t|
  #     t.change :subscription_status, :string, default: "active"
  #     t.change :plan, :string, default: "free"
  #   end
  # end

  # def down
  #   change_table :tasks do |t|
  #     t.change :subscription_status, :string, default: "incomplete"
  #     t.change :plan, :string
  #   end
  # end
end
