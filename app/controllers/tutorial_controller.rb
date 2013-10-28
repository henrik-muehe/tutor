require 'awesome_print'

class TutorialController < ApplicationController
	before_filter :authenticate_user!

	def settings
		@group = Group.find(params["group_id"])
		m = params["min"].to_i
		return render :status => 400, :json => { error: "Minutes must be between 0 and 59" } if m < 0 || m > 59
		o = @group.start
		@group.start=Time.mktime(o.year, o.month, o.day, o.hour, m)
		@group.save
		@group.touch
		return render :status => 200, :json => {}
	end

	def create_student
		@group = Group.find(params["group_id"])
		@week = Week.find(params["week_id"])

		return render :status => 400, :json => { error: "MatrNr is taken, search for the student first!" } if Student.where(:matrnr => params["matrnr"].to_i).length > 0
		return render :status => 400, :json => { error: "Email is taken, search for the student first!" } if Student.where(:email => params["email"].to_i).length > 0
		return render :status => 400, :json => { error: "Name too short!" } if params["firstname"].length < 3 or params["lastname"].length < 3

		s = Student.create(
			firstname: params["firstname"],
			lastname: params["lastname"],
			matrnr: params["matrnr"].to_i,
			email: params["email"]
		)
		s.groups << Group.find(params["group_id"])
		s.save
		render :partial => "students_row", :layout => false, :locals => { :s => s }
	end

	def move
		@group = Group.find(params["group_id"])
		@student = Student.find(params["student_id"])
		@week = Week.find(params["week_id"])
		ap params
		if params["mode"] == "temp"
			a = Assessment.where(:student => @student, :week => @week).first
			a = Assessment.new(:student => @student, :week => @week, :user => current_user, :value => 0, :group => @group) if a.nil?
			a.group = @group
			a.save
		else
			@student.groups.delete @student.groups.where(:course => @group.course)
			@student.groups << @group
			@student.save
		end
		render :partial => "students_row", :layout => false, :locals => { :s => @student }
	end

	def search
		@results = Student.where("(firstname||' '||lastname||' '||matrnr) like ?", "%#{params['term']}%").to_a
		# @group = Group.find(params["group_id"])
		# @results=[]
		# @group.course.groups.each do |g| 
		# 	g.students.where("(firstname||' '||lastname||' '||matrnr) like ?", "%#{params['term']}%").each do |s|
		# 		@results << s
		# 	end
		# end
	end

	def assess
		@assessment = Assessment.where(
			:week_id => params["assessment"]["week_id"],
			:student_id => params["assessment"]["student_id"]
		).first
		if not @assessment
			@assessment = Assessment.create(assess_params)
		else
			@assessment.update(assess_params)
		end
		@assessment.save
	end

	def assess_params
      params.require(:assessment).permit(:user_id, :value, :student_id, :week_id, :remark, :group_id)
	end

 	def index
 		return if current_user.groups.length == 0

		# Find course and group
		if params["course_id"] then
			@group = Course.find(params["course_id"]).groups.first
		elsif params["group_id"] then
			@group = Group.find(params["group_id"])
		elsif current_user.groups.length > 0
			dist=(Time.now - Chronic.parse('last Monday 0:00', :now => Time.now + 3600*24)).abs
			@group = current_user.groups.to_a.min_by do |g| 
				((Chronic.parse('last Monday 0:00', :now => g.start+3600*24) + dist) - g.start).abs + (Time.now - g.course.created_at)
			end
		 else
			@group = Group.all().first
		 end

		 # Find most sensible week
		 if params["week_id"] then
			@week = Week.find(params["week_id"])
		 else
			@week = @group.course.weeks.where("start <= ?", Time.now).min_by { |w| (Time.now - w.start).abs }
		 end

		 # Find all students
		 @students = @group.students + Assessment.where(:group => @group, :week => @week).map { |a| a.student }
		 @students.uniq!
		 @students.sort! { |a,b| a.lastname <=> b.lastname }
	end
end
