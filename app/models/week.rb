class Week < ActiveRecord::Base
	belongs_to :course
	has_many :assessments

	def select_name
		start.strftime("Week of %b %d")
	end
end
