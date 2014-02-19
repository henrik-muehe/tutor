require 'time'
require 'date'

class Group < ActiveRecord::Base
	belongs_to :course
	belongs_to :user
	has_and_belongs_to_many :students
	has_many :assessments

	DAYS = [['Monday', 1], ['Tuesday', 2], ['Wednesday', 3], ['Thursday', 4], ['Friday', 5], ['Saturday', 6], ['Sunday', 7]]
	HOURS = (0..23).map { |i| ["%02d" % i,i] }
	MINUTES = (0..11).map { |i| ["%02d" % (i*5),i*5] }

	def select_name
		"#{name} (#{start.strftime("%a %H:%M")})"
	end

	def day
		@start ||= DateTime.new(2012,10,01,12,0)
		DateTime.parse(@start.to_s).day
	end

	def hour
		@start ||= DateTime.new(2012,10,01,12,0)
		DateTime.parse(@start.to_s).hour
	end

	def minute
		@start ||= DateTime.new(2012,10,01,12,0)
		DateTime.parse(@start.to_s).minute
	end

	def day=(v)
		@start ||= DateTime.new(2012,10,01,0,0)
		@start = DateTime.parse(@start.to_s).change({ :day => v.to_i })
		write_attribute(:start,@start)
	end

	def hour=(v)
		@start ||= DateTime.new(2012,10,01,0,0)
		@start = DateTime.parse(@start.to_s).change({ :hour => v.to_i })
		write_attribute(:start,@start)
		p @start
	end

	def minute=(v)
		@start ||= DateTime.new(2012,10,01,0,0)
		@start = DateTime.parse(@start.to_s).change({ :min => v.to_i })
		write_attribute(:start,@start)
	end

	def time_in_week(week)
		slotMonday = Chronic.parse('last Monday 0:00', :now => self.start+3600*24)
		realMonday = week.start
		dist = self.start - slotMonday
		(realMonday + dist)
	end
end
