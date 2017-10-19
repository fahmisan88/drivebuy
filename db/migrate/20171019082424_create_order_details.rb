class CreateOrderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :order_details do |t|
      t.references :order, foreign_key: true
      t.references :meal, foreign_key: true
      t.integer :quantity
      t.decimal :sub_total

      t.timestamps
    end
  end
end
