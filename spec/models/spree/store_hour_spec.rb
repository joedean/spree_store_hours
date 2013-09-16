require 'spec_helper'
describe Spree::StoreHour do
  let(:store_hour_with_no_day) { Spree::StoreHour.new }
  let(:store_hour) { Spree::StoreHour.new(wday: 1, open_time: '8:00 am', close_time: '5:00 pm') }
  subject { store_hour }

  it "is invalid without a wday" do
    store_hour_with_no_day.should_not be_valid
  end

  it "changes the number of days defined with business hours" do
    expect { store_hour.save }.to change { Spree::StoreHour.count }.by(1)
  end

  it "has hours if there is an open and close time" do
    store_hour.open_time.should == '8:00 am'
    store_hour.close_time.should == '5:00 pm'
  end

  describe ".for" do
    it "returns nil if day name is not provided" do
      Spree::StoreHour.for.nil?.should  be_true
    end
  end

  context "gets store hours when" do
    let!(:sunday_hours) { FactoryGirl.create(:spree_store_hour, :wday => 0, :open_time => '1:00 pm', :close_time => '10:00 pm') }
    let!(:monday_hours) { FactoryGirl.create(:spree_store_hour, :wday => 1, :open_time => '7:00 am', :close_time => '3:00 pm') }
    let!(:tuesday_hours) { FactoryGirl.create(:spree_store_hour, :wday => 2, :open_time => '8:00 am', :close_time => '4:00 pm') }
    let!(:wednesday_hours) { FactoryGirl.create(:spree_store_hour, :wday => 3, :open_time => '9:00 am', :close_time => '5:00 pm') }
    let!(:thursday_hours) { FactoryGirl.create(:spree_store_hour, :wday => 4, :open_time => '10:00 am', :close_time => '6:00 pm') }
    let!(:friday_hours) { FactoryGirl.create(:spree_store_hour, :wday => 5, :open_time => '11:00 am', :close_time => '7:00 pm') }
    let!(:saturday_hours) { FactoryGirl.create(:spree_store_hour, :wday => 6, :open_time => '12:00 pm', :close_time => '8:00 pm') }

    it "has every day of the week defined in the database" do
      store_hours = Spree::StoreHour.all
      store_hours.size.should == 7
      store_hours.map(&:day).should == ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
      store_hours.map(&:abbr_day).should == ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
      store_hours.map(&:open_time).should == ['1:00 pm', '7:00 am', '8:00 am', '9:00 am', '10:00 am', '11:00 am', '12:00 pm']
      store_hours.map(&:close_time).should == ['10:00 pm', '3:00 pm', '4:00 pm', '5:00 pm', '6:00 pm', '7:00 pm', '8:00 pm']
    end

    it "provides a specific day of the week" do
      monday_store_hours = Spree::StoreHour.for :monday
      monday_store_hours.day.should == "Monday"
      monday_store_hours.abbr_day.should == "Mon"
      monday_store_hours.open_time == '7:00 am'
      monday_store_hours.close_time == '3:00 pm'
    end

    it "provides today" do
      Timecop.freeze(Time.local(2012, 9, 1, 12, 0, 0))
      todays_store_hours = Spree::StoreHour.for :today
      todays_store_hours.day.should == "Saturday"
      todays_store_hours.abbr_day.should == "Sat"
      todays_store_hours.open_time == '12:00 pm'
      todays_store_hours.close_time == '8:00 pm'
      Timecop.return
     end
  end

  context "is closed when" do
    let!(:monday_hours) { FactoryGirl.create(:spree_store_hour, :wday => 1, :open_time => '7:00 am', :close_time => nil) }
    let!(:tuesday_hours) { FactoryGirl.create(:spree_store_hour, :wday => 2, :open_time => nil, :close_time => '4:00 pm') }
    let!(:wednesday_hours) { FactoryGirl.create(:spree_store_hour, :wday => 3, :open_time => nil, :close_time => nil) }

    it "has no close time" do
      Spree::StoreHour.for(:monday).should be_closed
    end
    it "has no open time" do
      Spree::StoreHour.for(:tuesday).should be_closed
    end
    it "has no open time or close time" do
      Spree::StoreHour.for(:wednesday).should be_closed
    end
    it "is not defined in the database" do
      Spree::StoreHour.for(:thursday).should be_closed
    end
  end

  # Potential future enhancements
  it "considers holiday business hours"
  it "supports other time formats"
end
