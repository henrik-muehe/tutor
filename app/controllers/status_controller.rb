class StatusController < ApplicationController
	def new
	end

	def create
		@student = Student.where(:matrnr => params["matrnr"]).first
		if not @student.present? then
			@error = "The MatrNr you supplied is invalid."
		elsif (Time.now - @student.updated_at) < 2*3600 then
			@error = "Sorry, you can only re-request every 2 hours."
		else
			t = ""
			while true
				t = rand(36**16).to_s(36)
				if Student.where(:token => t).length == 0 then
					break
				end
			end
			@student.token = t
			@student.save
			StatusMailer.new(@student).deliver
		end
	end

	def show
		@student = Student.where(:token => params["token"]).first
		if not @student.present?
			return render_404
		end
	end

	def schedule
	end
end
