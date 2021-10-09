class UsersController < ApplicationController
  
  include UsersHelper
  include ApplicationHelper 
  helper ApplicationHelper



  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # === custom define ===

  def login_page
    @tmp = User.new #simple form cant work with nil 
    session[:user_id] = nil
  end

  def login
    login_user = params[:user] #simple form pass "user = {email:"", password:""} to this func"
    
    #authenticate
    exist_user = User.find_by(email: login_user[:email])
    
    if(exist_user != nil) 
      exist_user = exist_user.authenticate(login_user[:password])
    else
      flash[:alert] = "Please Register!!"
      render :login_page
      return
    end 

    if (exist_user != false)
      flash[:success] = "Login successfully"
      redirect_to users_path
    else 
      flash[:alert] = "Wrong Email or Password!!"
      render :login_page
    end
  end

  # === end custom define ===

  private
    # Use callbacks to share common setup or constraints between actions.

    # ==== custom define ====
    def is_logged_in
      if (session[:user_id] != nil)
        return true;
      else 
        redirect_to :login_page, notice: "Please Login"
      end
    end



    # ==== end custom define ====
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :name, :password, :age)
      #this just return obj in the line above
    end
end
