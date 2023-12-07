class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :name
      t.references :member, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
