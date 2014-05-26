class AddColumnClosedToStoreHours < ActiveRecord::Migration
  def change
    add_column :store_hours, :closed, :boolean, default: false
  end
end
