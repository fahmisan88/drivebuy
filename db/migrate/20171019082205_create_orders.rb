class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :restaurant, foreign_key: true
      t.references :customer, foreign_key: true
      t.decimal :total
      t.integer :status
      t.datetime :picked_at

      t.timestamps
    end
  end
end
