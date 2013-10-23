class Assessment < ActiveRecord::Base
	belongs_to :user
	belongs_to :student
	belongs_to :week
	belongs_to :group
end
