class AddNotificationPreferencesToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :notify_account_activity, :boolean
    add_column :users, :notify_weekly_summary, :boolean
    add_column :users, :notify_new_stock, :boolean
    add_column :users, :notify_low_stock, :boolean
    add_column :users, :notify_price_updates, :boolean
  end
end
