class AddCategoryToStocks < ActiveRecord::Migration[8.1]
  def change
    add_column :stocks, :category, :string
  end
end
