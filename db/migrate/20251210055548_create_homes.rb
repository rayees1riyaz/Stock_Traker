class CreateHomes < ActiveRecord::Migration[8.1]
  def change
    create_table :homes do |t|
      t.timestamps
    end
  end
end
