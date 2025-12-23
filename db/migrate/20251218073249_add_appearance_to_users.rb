class AddAppearanceToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :theme, :string
    add_column :users, :density, :string
  end
end
