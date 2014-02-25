class ExamTask < ActiveRecord::Base
	belongs_to :exam

	#validates :exam, presence: true
	validates :max_points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
	validates :number, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
