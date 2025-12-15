class AddShopNameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :shop_name, :string
  end
end
