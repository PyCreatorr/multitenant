class AddTenantColor < ActiveRecord::Migration[7.0]
  def change
    add_column :tenants, :font_color, :string
    add_column :tenants, :bg_color, :string
  end
end
