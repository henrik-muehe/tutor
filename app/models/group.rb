class Group < ActiveRecord::Base
	belongs_to :course
	belongs_to :user
	has_and_belongs_to_many :students
	has_many :assessments

	def select_name
		"#{name} (#{start.strftime("%a %H:%M")})"
	end

	def time_in_week(week)
		slotMonday = Chronic.parse('last Monday 0:00', :now => self.start+3600*24)
		realMonday = week.start
		dist = self.start - slotMonday
		(realMonday + dist)
	end
end
