class Student < ActiveRecord::Base
	has_and_belongs_to_many :groups
	has_many :assessments

	def total
		0
	end
end
