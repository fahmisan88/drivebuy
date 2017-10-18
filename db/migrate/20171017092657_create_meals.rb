class CreateMeals < ActiveRecord::Migration[5.1]
  def change
    create_table :meals do |t|
      t.references :restaurant, foreign_key: true
      t.string :name
      t.string :desc
      t.decimal :price
      t.boolean :available, default: true

      t.timestamps
    end
  end
end
