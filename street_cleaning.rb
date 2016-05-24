#!/usr/bin/env ruby
# frozen_string_literal: true
# April 1st to Nov 30th
# 4th Monday (north) and Tuesday (south)
# 8:30am to 2:00pm

require 'chronic'
require 'date'
require 'time'
require 'icalendar'
require 'icalendar/tzinfo'

def set_time_on_date(date, time)
  parts = date.to_a
  time_parts = time.to_a
  (0..2).each { |i| parts[i] = time_parts[i] }
  Time.local(*parts)
end

# A cleaning day event
class CleaningDay
  attr_reader :start, :stop
  START_TIME = Time.parse('8:30am')
  STOP_TIME  = Time.parse('2pm')
  DAYS_OF_WEEK = %w(Monday Tuesday).freeze
  MONTHS = %w(April May June July August September October November).freeze
  TZID = 'America/New_York'.freeze

  def initialize(date)
    @start = set_time_on_date(date, START_TIME).freeze
    @stop  = set_time_on_date(date, STOP_TIME).freeze
  end

  def day
    @start.strftime '%A'
  end

  def street_side
    return 'North' if @start.monday?
    return 'South' if @start.tuesday?
    fail "I don't know about #{day}"
  end

  def to_s
    "#{day} #{start.iso8601} to #{stop.iso8601}"
  end

  def advice
    "Don't park on the #{street_side} side of the street."
  end

  def to_ics
    Icalendar::Event.new.tap do |event|
      event.dtstart = Icalendar::Values::DateTime.new start, 'tzid' => TZID
      event.dtend = Icalendar::Values::DateTime.new stop, 'tzid' => TZID
      event.summary = advice
    end
  end

  def inspect
    "<CleaningDay #{self}>"
  end

  def self.one_year
    today = Date.today
    now = Time.local(today.year, today.month, 1)

    MONTHS.map do |month|
      DAYS_OF_WEEK.map do |day|
        expr = "the 4th #{day} in #{month}"
        date = Chronic.parse(expr, now: now)
        CleaningDay.new date
      end
    end.flatten
  end
end

if $PROGRAM_NAME == __FILE__
  cal = Icalendar::Calendar.new
  CleaningDay.one_year.each { |e| cal.add_event(e.to_ics) }

  open('calendar.ics', 'w') do |f|
    f.write cal.to_ical
  end
end
