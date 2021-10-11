class UsersController < ApplicationController

  include UsersHelper
  include ApplicationHelper 
  helper ApplicationHelper


  before_action :is_logged_in, only: %i[feed show_post_by_name new_post]
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
      flash[:success] = "Login Successfully"
      session[:user_id] = exist_user.id
      @user = exist_user
      puts "-----------------------------login as #{@user.name}"
      puts "-----------------------------following #{@user.following}"
      redirect_to "/feed"
    else 
      flash[:alert] = "Wrong Email or Password!!"
      render :login_page
    end

  end

  def feed
    c_user = User.find(session[:user_id])
    @display_posts = []
    c_user.following.each do |f_id|
      user = User.find(f_id)
        user.posts.each do |post|
          @display_posts.push(post)
        end
    end
    @display_posts.sort_by!{|post| post.created_at}
  end

  def show_post_by_name
    @profile_user = User.find_by(name: params[:name])
    if @profile_user == nil
      flash[:alert] = "Profile not found, Please try again!"
      redirect_to :feed
    end
  end

  def new_post

  end

  def create_post
    puts "============msg : #{params[:post][:msg]}"
    new_post = Post.create(msg: params[:post][:msg], user_id: session[:user_id])
    flash[:success] = "Create post Successfully!!"
    redirect_to :feed
  end
  
  def follow_by_id
    @user = User.find(session[:user_id])
    follow_user = User.find(params[:user_id])
    @user.following.push(follow_user.id)
    @user.save
    flash[:success] = "Follow \"#{follow_user.name}\" Successfully!!"
    redirect_to :feed
  end

  def unfollow_by_id
    @user = User.find(session[:user_id])
    unfollow_user = User.find(params[:user_id])
    @user.following.delete(unfollow_user.id)
    @user.save
    flash[:success] = "Unfollow \"#{unfollow_user.name}\" Successfully!!"
    redirect_to :feed
  end
  # === end custom define ===

  private
    # Use callbacks to share common setup or constraints between actions.

    # ==== custom define ====
    def is_logged_in
      if (session[:user_id] != nil)
        @user = User.find(session[:user_id])
        return true;
      else 
        redirect_to :main, notice: "Please Login"
      end
    end

    def is_same_acc
      if (@user.id == nil || session[:user_id] == nil || session[:user_id] != @user.id)
        return false;
      else 
        return true
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
