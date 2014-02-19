class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:magiclogin]
  before_filter :admincheck, except: [:magiclogin]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :reset, :associate]

  def reset
    flash[:notice]="Reset email send to user #{@user.name}."
    @user.send_reset_password_instructions()
    redirect_to "/users/"
  end

  def associate
    #flash[:notice]="Associated user #{@user.email} with course #{session[:course].name}."

    if session[:course].users.where(:id => @user.id).present?
      session[:course].users.delete(@user.id)
    else
      session[:course].users << @user
    end

    redirect_to "/users/"
  end

  def magiclogin
    u = User.where(:id => params[:id], :magictoken => params[:magictoken]).first
    if u.present? then
      sign_in(:user, u)
      redirect_to '/'
    else
      return render :inline => "sorry but you did not provide valid magic login credentials"
    end
  end

  def import
    text = params["user"]["file"].tempfile.read
    text.split("\n").each do |line|
      cols=line.split(";")
      name = cols[0].to_s
      email = cols[1].to_s
      @user = User.create(:email => email, :password => 'asklfjsdkfjasd', :password_confirmation => 'asklfjsdkfjasd')
    end
  end

  # GET /users
  # GET /users.json
  def index
    @course_users = session[:course].users
    @users = User.where(["id not in (?)", @course_users.map{|u| u.id}+[-1]]).order(["role DESC",:lastname,:firstname])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email,:firstname,:lastname,:magictoken,:password,:password_confirmation,:role)
    end
end
