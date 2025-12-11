class CreateStocks < ActiveRecord::Migration[8.1]
def change
    create_table :stocks do |t|
      t.string :brand
      t.string :model
      t.decimal :price, precision: 10, scale: 2
      t.integer :quantity
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
