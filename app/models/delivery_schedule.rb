class DeliverySchedule
  include ActiveModel::Model

  MIN_AVAILABLE_BUSINESS_DAY = 3
  MAX_AVAILABLE_BUSINESS_DAY = 14
  TIME_SEPARATOR = '-'

  def self.split_times times
    times.split(TIME_SEPARATOR)
  end

  def self.concat_times time1, time2
    time1 = time1.strftime('%R') if time1.is_a? Time
    time2 = time2.strftime('%R') if time2.is_a? Time
    "#{time1}#{TIME_SEPARATOR}#{time2}"
  end

  def self.business_day? date
    date.cwday <= 5
  end

  def initialize base_date = Date.today
    @base_date = base_date
  end

  def deliverable_dates
    dates = []
    @base_date.upto(@base_date + 100).each do |date|
      dates << date if DeliverySchedule.business_day?(date)
      break if dates.size >= MAX_AVAILABLE_BUSINESS_DAY
    end

    (MIN_AVAILABLE_BUSINESS_DAY - 1).times do
      dates.shift
    end
    dates
  end

  def deliverable? date
    self.business_dates.include?(date)
  end

  def deliverable_splitted_times
    [
      [ '8:00', '12:00'],
      ['12:00', '14:00'],
      ['14:00', '16:00'],
      ['16:00', '18:00'],
      ['18:00', '20:00'],
      ['20:00', '21:00'],
    ]
  end

  def deliverable_times
    deliverable_splitted_times.map {|times| DeliverySchedule.concat_times(times.first, times.last)}
  end

end
