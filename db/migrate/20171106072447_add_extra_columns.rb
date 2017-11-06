class AddExtraColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :open, :boolean, default: false
    add_column :restaurants, :status, :integer, default: 0
    add_column :orders, :method, :integer
    add_column :orders, :remark, :string
    add_column :customers, :status, :integer, default: 0
    add_column :meals, :meal_type, :integer
  end
end
