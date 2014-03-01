class Analysis < ActiveRecord::Base
	def execute(course_id,exam_id)
		return [] if not query.present? 
		ActiveRecord::Base.connection().execute(query.gsub("$COURSE_ID", course_id.to_s).gsub("$EXAM_ID", exam_id.to_s))
	end
end
