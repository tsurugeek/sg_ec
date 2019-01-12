require 'rails_helper'

RSpec.describe DeliverySchedule, type: :model do
  context ".split_times" do
    it "returns [nil, nil] when arg is nil" do
      expect(DeliverySchedule.split_times(nil)).to eq [nil, nil]
    end
    it "returns [nil, nil] when arg is ''" do
      expect(DeliverySchedule.split_times('')).to eq [nil, nil]
    end
    it "returns ['xx:xx, xx:xx'] when arg is 'xx:xx-xx:xx' format" do
      expect(DeliverySchedule.split_times('xx:xx-xx:xx')).to eq ['xx:xx', 'xx:xx']
    end

    it "フォーマットが間違っている場合は例外をあげる"
  end

  context ".concat_times" do
    it "returns ['xx:xx, xx:xx'] when arg is 'xx:xx-xx:xx' format" do
      expect(DeliverySchedule.concat_times('xx:xx', 'xx:xx')).to eq 'xx:xx-xx:xx'
    end

    it "フォーマットが間違っている場合は例外をあげる"
  end

  context ".business_day?" do
    it "returns true when the arg is Monday, Tuesday, Wednesday, Thursday or Friday" do
      expect(DeliverySchedule.business_day?(Date.parse('2019-01-07'))).to be true
      expect(DeliverySchedule.business_day?(Date.parse('2019-01-08'))).to be true
      expect(DeliverySchedule.business_day?(Date.parse('2019-01-09'))).to be true
      expect(DeliverySchedule.business_day?(Date.parse('2019-01-10'))).to be true
      expect(DeliverySchedule.business_day?(Date.parse('2019-01-11'))).to be true
    end

    it "returns false when the arg is Saturday or Sunday" do
      expect(DeliverySchedule.business_day?(Date.parse('2019-01-12'))).to be false
      expect(DeliverySchedule.business_day?(Date.parse('2019-01-13'))).to be false
    end
  end

  context "#deliverable_dates" do
    it "returns dates array between 3rd buisiness day and 14th businessday based on the base_date(arg of initialize method)" do
      delivery_schedule = DeliverySchedule.new(Date.parse('2019-01-01'))
      expect(delivery_schedule.deliverable_dates).to eq [
        Date.parse('2019-01-03'),
        Date.parse('2019-01-04'),
        Date.parse('2019-01-07'),
        Date.parse('2019-01-08'),
        Date.parse('2019-01-09'),
        Date.parse('2019-01-10'),
        Date.parse('2019-01-11'),
        Date.parse('2019-01-14'),
        Date.parse('2019-01-15'),
        Date.parse('2019-01-16'),
        Date.parse('2019-01-17'),
        Date.parse('2019-01-18'),
      ]
    end
  end

  context "#deliverable?" do
    it "returns false when the arg is NOT in result of deliverable_dates method" do
      delivery_schedule = DeliverySchedule.new(Date.parse('2019-01-01'))
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-01'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-02'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-03'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-04'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-05'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-06'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-07'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-08'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-09'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-10'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-11'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-12'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-13'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-14'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-15'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-16'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-17'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-18'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-19'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-20'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-21'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-22'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-23'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-24'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-25'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-26'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-27'))).to be false
    end

    it "returns true when the arg is in result of deliverable_dates method" do
      delivery_schedule = DeliverySchedule.new(Date.parse('2019-01-01'))
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-01'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-02'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-03'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-04'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-05'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-06'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-07'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-08'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-09'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-10'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-11'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-12'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-13'))).to be false
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-14'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-15'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-16'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-17'))).to be true
      expect(delivery_schedule.deliverable?(Date.parse('2019-01-18'))).to be true
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-19'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-20'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-21'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-22'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-23'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-24'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-25'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-26'))).to be false
      # expect(delivery_schedule.deliverable?(Date.parse('2019-01-27'))).to be false
    end
  end

  context "#deliverable_splitted_times" do
    let(:delivery_schedule){ DeliverySchedule.new }
    it "returns a array which includes ['08:00', '12:00']" do
      expect(delivery_schedule.deliverable_splitted_times).to include ['08:00', '12:00']
    end
    it "returns a array which includes ['12:00', '14:00']" do
      expect(delivery_schedule.deliverable_splitted_times).to include ['12:00', '14:00']
    end
    it "returns a array which includes ['14:00', '16:00']" do
      expect(delivery_schedule.deliverable_splitted_times).to include ['14:00', '16:00']
    end
    it "returns a array which includes ['16:00', '18:00']" do
      expect(delivery_schedule.deliverable_splitted_times).to include ['16:00', '18:00']
    end
    it "returns a array which includes ['18:00', '20:00']" do
      expect(delivery_schedule.deliverable_splitted_times).to include ['18:00', '20:00']
    end
    it "returns a array which includes ['20:00', '21:00']" do
      expect(delivery_schedule.deliverable_splitted_times).to include ['20:00', '21:00']
    end
    it "returns a array which elements size is 6" do
      expect(delivery_schedule.deliverable_splitted_times.size).to eq 6
    end
  end

  context "#deliverable_times" do
    let(:delivery_schedule){ DeliverySchedule.new }
    it "returns a string array which includes '08:00-12:00'" do
      expect(delivery_schedule.deliverable_times).to include '08:00-12:00'
    end
    it "returns a array which includes '12:00-14:00'" do
      expect(delivery_schedule.deliverable_times).to include '12:00-14:00'
    end
    it "returns a array which includes '14:00-16:00'" do
      expect(delivery_schedule.deliverable_times).to include '14:00-16:00'
    end
    it "returns a array which includes '16:00-18:00'" do
      expect(delivery_schedule.deliverable_times).to include '16:00-18:00'
    end
    it "returns a array which includes '18:00-20:00'" do
      expect(delivery_schedule.deliverable_times).to include '18:00-20:00'
    end
    it "returns a array which includes '20:00-21:00'" do
      expect(delivery_schedule.deliverable_times).to include '20:00-21:00'
    end
    it "returns a array which elements size is 6" do
      expect(delivery_schedule.deliverable_times.size).to eq 6
    end
  end
end
