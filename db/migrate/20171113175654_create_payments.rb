class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :order, foreign_key: true
      t.references :restaurant, foreign_key: true
      t.references :customer, foreign_key: true
      t.string :method
      t.string :txid
      t.integer :status, default: 2
      t.string :message
      t.decimal :amount

      t.timestamps
    end
    add_column :meals, :code, :string
  end
end
