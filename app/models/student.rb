class Student < ActiveRecord::Base
	has_and_belongs_to_many :groups
	has_and_belongs_to_many :exams
	has_many :assessments

	def total(course, limit=Time.now)
		groups = course.groups
		weeks = course.weeks.where("start <= Datetime(?)", limit)
		weekAssessments = assessments.where("group_id in (?) and week_id in (?)", groups, weeks)
		value = -(weeks.length - weekAssessments.length); weekAssessments.each { |a| value += a.value }
		value
	end
end
