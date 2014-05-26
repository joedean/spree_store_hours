require 'spec_helper'

describe Spree::StoreHour do
  let(:store_hour) { Spree::StoreHour.new(wday: 1, open_time: '8:00 am', close_time: '5:00 pm') }
  subject { store_hour }

  it "changes the number of days defined with business hours" do
    expect { store_hour.save }.to change { Spree::StoreHour.count }.by(1)
  end

  context "store hour with no day" do
    let(:store_hour) { Spree::StoreHour.new }

    it "is invalid without a wday" do
      expect(store_hour).to be_invalid
    end
  end

  context "An open and close time exist" do
    let(:store_hour) { build(:spree_store_hour, open_time: '8:00 am', close_time: '5:00 pm') }

    it "has hours for open and close times" do
      expect(store_hour.open_time).to eq '8:00 am'
      expect(store_hour.close_time).to eq '5:00 pm'
    end
  end

  context "all store hours loaded into the database" do
    let!(:sunday_hours) { create(:spree_store_hour, :wday => 0, :open_time => '1:00 pm', :close_time => '10:00 pm') }
    let!(:monday_hours) { create(:spree_store_hour, :wday => 1, :open_time => '7:00 am', :close_time => '3:00 pm') }
    let!(:tuesday_hours) { create(:spree_store_hour, :wday => 2, :open_time => '8:00 am', :close_time => '4:00 pm') }
    let!(:wednesday_hours) { create(:spree_store_hour, :wday => 3, :open_time => '9:00 am', :close_time => '5:00 pm') }
    let!(:thursday_hours) { create(:spree_store_hour, :wday => 4, :open_time => '10:00 am', :close_time => '6:00 pm') }
    let!(:friday_hours) { create(:spree_store_hour, :wday => 5, :open_time => '11:00 am', :close_time => '7:00 pm') }
    let!(:saturday_hours) { create(:spree_store_hour, :wday => 6, :open_time => '12:00 pm', :close_time => '8:00 pm') }
    let(:store_hours) { Spree::StoreHour.all }

    it "has 7 days" do
      expect(store_hours.size).to eq 7
    end

    it "has each day of the week" do
      expect(store_hours.map(&:day)).to eq ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    end

    it "has each abbreviated day of the week" do
      expect(store_hours.map(&:abbr_day)).to eq ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    end

    it "has open time of each day of the week" do
      expect(store_hours.map(&:open_time)).to eq ['1:00 pm', '7:00 am', '8:00 am', '9:00 am', '10:00 am', '11:00 am', '12:00 pm']
    end

    it "has close time of each day of the week" do
      expect(store_hours.map(&:close_time)).to eq ['10:00 pm', '3:00 pm', '4:00 pm', '5:00 pm', '6:00 pm', '7:00 pm', '8:00 pm']
    end
  end

  describe ".list" do
    context "database has a list of days loaded" do
      let!(:tuesday_hours) { create(:spree_store_hour, :wday => 2, :open_time => '8:00 am', :close_time => '4:00 pm') }
      let!(:monday_hours) { create(:spree_store_hour, :wday => 1, :open_time => '7:00 am', :close_time => '3:00 pm') }

      it "returns an ordered list of days" do
        expect(Spree::StoreHour.list).to eq [monday_hours, tuesday_hours]
      end
    end
  end

  describe ".for" do
    context "day name is not provided" do
      let(:day_name) { nil }
      it "returns nil" do
        expect(Spree::StoreHour.for day_name).to be_nil
      end
    end

    context "day name 'Today' is provided" do
      let(:day_name) { :today }

      it "returns day name for today" do
        Timecop.freeze(Time.local(2014, 5, 26, 12, 0, 0))
        expect(Date::DAYNAMES[Spree::StoreHour.for(day_name).wday]).to eq "Monday"
        Timecop.return
      end
    end

    context "store hours exist in the database" do
      let!(:monday_hours) { create :spree_store_hour, :wday => 1, :open_time => '1:00 pm', :close_time => '10:00 pm' }

      context "A day name provided" do
        let(:day_name) { :monday }

        it "returns provided day name's store hours" do
          expect(Spree::StoreHour.for(day_name)).to eq monday_hours
        end
      end
    end
  end

  context "Tuesday hours loaded in database" do
    let(:open_time) { '8:00 am' }
    let(:close_time) { '4:00 pm' }
    let(:closed) { false }
    let!(:tuesday_hours) { create(:spree_store_hour, :wday => 2, open_time: open_time, close_time: close_time) }

    describe "#day" do
      it "gives the day name" do
        expect(tuesday_hours.day).to eq "Tuesday"
      end
    end

    describe "#abbr_day" do
      it "gives the abbreviated day name" do
        expect(tuesday_hours.abbr_day).to eq "Tue"
      end
    end

    describe "#open_time" do
      it "provides a properly formatted open time" do
        expect(tuesday_hours.open_time).to eq "8:00 am"
      end
    end

    describe "#close_time" do
      it "provides a properly formatted open time" do
        expect(tuesday_hours.close_time).to eq "4:00 pm"
      end
    end

    describe "#closed?" do
      context "has an open and closed time" do
        context "closed attribute is false" do
          let(:closed) { false }

          it "is not closed" do
            expect(tuesday_hours).to_not be_closed
          end
        end

        context "closed attribute is true" do
          let(:closed) { true }

          it "is not closed" do
            expect(tuesday_hours).to_not be_closed
          end
        end
      end

      context "has no open time" do
        let(:open_time) { nil }

        it "is closed" do
          expect(tuesday_hours).to be_closed
        end
      end

      context "has no closed time" do
        let(:close_time) { nil }

        it "is closed" do
          expect(tuesday_hours).to be_closed
        end
      end


      context "has no open time and no closed time" do
        let(:open_time) { nil }
        let(:close_time) { nil }

        it "is closed" do
          expect(tuesday_hours).to be_closed
        end
      end

      context "day is not defined in the database" do
        it "is closed" do
          Spree::StoreHour.for(:thursday).should be_closed
        end
      end
    end
  end

  # Potential future enhancements
  it "considers holiday business hours"
  it "supports other time formats"
end
