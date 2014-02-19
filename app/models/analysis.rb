class Analysis < ActiveRecord::Base
	def execute(course)
		return [] if not query.present? 
		ActiveRecord::Base.connection().execute(query.gsub("$COURSE_ID", course.id.to_s))
	end
end
