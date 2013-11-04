class AnalysesController < ApplicationController
	before_filter :authenticate_user!
	before_filter do 
		unless current_user && current_user.admin
			flash[:notice]="No access." 
			redirect_to "/tutorial"
		end
	end
	before_action :set_analysis, only: [:show, :edit, :update, :destroy]

	# GET /analyses
	# GET /analyses.json
	def index
		@analyses = Analysis.all
	end

	# GET /analyses/1
	# GET /analyses/1.json
	def show
	end

	def execute
		a = Analysis.where(:id => params["id"]).first
		a = Analysis.new if not a.present?
		a.query=params["query"]
		a.view=params["view"]
		render :partial => "analysis", :locals => { :a => a }, :layout => false
	end

	# GET /analyses/new
	def new
		@analysis = Analysis.new
	end

	# GET /analyses/1/edit
	def edit
	end

	# POST /analyses
	# POST /analyses.json
	def create
		@analysis = Analysis.new(analysis_params)

		respond_to do |format|
			if @analysis.save
				format.html { redirect_to @analysis, notice: 'Analysis was successfully created.' }
				format.json { render action: 'show', status: :created, location: @analysis }
			else
				format.html { render action: 'new' }
				format.json { render json: @analysis.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /analyses/1
	# PATCH/PUT /analyses/1.json
	def update
		respond_to do |format|
			if @analysis.update(analysis_params)
				format.html { redirect_to @analysis, notice: 'Analysis was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @analysis.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /analyses/1
	# DELETE /analyses/1.json
	def destroy
		@analysis.destroy
		respond_to do |format|
			format.html { redirect_to analyses_url }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_analysis
			@analysis = Analysis.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def analysis_params
			params.require(:analysis).permit(:name, :query, :admin, :view)
		end
end
