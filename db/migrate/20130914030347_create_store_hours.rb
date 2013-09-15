class CreateStoreHours < ActiveRecord::Migration
  def change
    create_table :spree_store_hours do |t|
      t.integer :wday, :null => false
      t.time    :open_time
      t.time    :close_time

      t.timestamps
    end
  end
end
