class GroupsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admincheck
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.where(:course_id => @course.id).sort { |a,b| a.name.gsub(/[^0-9]/,'').to_i <=> b.name.gsub(/[^0-9]/,'').to_i }
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to :groups
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    if @group.update(group_params)
      redirect_to :groups, notice: 'Group was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    redirect_to :groups
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :user_id, :course_id, :hour, :minute, :day)
    end
end
