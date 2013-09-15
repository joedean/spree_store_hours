class Spree::Admin::StoreHoursController < Spree::Admin::ResourceController
  def index
    @store_hours = Spree::StoreHour.list
  end
end
