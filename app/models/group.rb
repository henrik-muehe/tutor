class Group < ActiveRecord::Base
	belongs_to :course
	belongs_to :user
	has_and_belongs_to_many :students
	has_many :assessments

	def select_name
		"#{name} (#{start.strftime("%a %H:%M")})"
	end
end
