# Seed days of the week for store hours
Date::DAYNAMES.each_index { |d|
  storeHour = Spree::StoreHour.where :wday => d
  Spree::StoreHour.create(:wday => d) if storeHour.empty?
}
