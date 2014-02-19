class Course < ActiveRecord::Base
	has_many :groups
	has_many :weeks
	has_and_belongs_to_many :users
end
