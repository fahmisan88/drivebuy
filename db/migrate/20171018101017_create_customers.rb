class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :phone
      t.string :plate_num
      t.string :car_desc
      t.float :lat
      t.float :long

      t.timestamps
    end
  end
end
