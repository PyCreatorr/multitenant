class ColorPickerBoard < ActiveRecord::Migration[7.0]
  def change
    add_column :boards, :font_color, :string
    add_column :boards, :bg_color, :string

    remove_column :tenants, :font_color, :string
    remove_column :tenants, :bg_color, :string
  end
end
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


  #end

