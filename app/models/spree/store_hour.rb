class Spree::StoreHour < ActiveRecord::Base
  attr_accessible :wday, :open_time, :close_time
  validates :wday, :presence => true

  def self.list
    order :wday
  end

  def self.for(day_name=nil)
    return nil unless day_name
    day_name = day_name.to_s.capitalize
    wday = Date::DAYNAMES.index day_name
    wday = Date.today.wday if day_name == "Today"
    result = where :wday => wday
    if result.empty?
      Spree::StoreHour.new :wday => wday
    else
      result.first
    end
  end

  def day
    Date::DAYNAMES[self[:wday]] if self[:wday]
  end

  def closed?
    open_time.nil? || close_time.nil?
  end

  def open_time
    format_time self[:open_time]
  end

  def open_time=(open_time)
    self[:open_time] = format_time(open_time)
  end

  def close_time
    format_time self[:close_time]
  end

  def close_time=(close_time)
    self[:close_time] = format_time(close_time)
  end

  private

  # Need to format time stamp becuase they are being returned with the
  # date and the time zone which isn't relevant when displaying store
  # hours.
  def format_time time
    return time if time.is_a? String
    time.strftime('%l:%M %P').strip if time
  end
end
