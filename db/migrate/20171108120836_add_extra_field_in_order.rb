class AddExtraFieldInOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :order_id, :string
    change_column :orders, :method, :integer, default: 0
    change_column :orders, :status, :integer, default: 0
  end
end
