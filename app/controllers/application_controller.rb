class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	def render_403
		respond_to do |format|
			format.html { render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false }
			format.json { render :json => { :error => true, :message => "Error 403, you don't have permissions for this operation." } }
		end
	end

	def render_404
		respond_to do |format|
			format.html { render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false }
			format.json { render :json => { :error => true, :message => "Error 404, page not found." } }
		end
	end
end
