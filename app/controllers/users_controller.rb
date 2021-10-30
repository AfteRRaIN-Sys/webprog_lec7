class UsersController < ApplicationController

  include UsersHelper
  include ApplicationHelper 
  helper ApplicationHelper

  #skip_before_action :verify_authenticity_token, only: %i[is_logged_in]
  before_action :is_logged_in, only: %i[feed show_post_by_name new_post follow_by_id unfollow_by_id like_post unlike_post]
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
      redirect_to "/feed"
    else 
      flash[:alert] = "Wrong Email or Password!!"
      render :login_page
    end

  end

  def feed
    c_user = User.find(session[:user_id])
    @display_posts = c_user.get_feed_post(session[:user_id])
    @like_user_in_each_post = []
    @display_posts.each do |post|
      tmp1 = []
      post.likes.each do |like|
        tmp1.append(User.find(like.user_id).name)
      end
      @like_user_in_each_post.append(tmp1.join(","))
    end
  end

  def show_post_by_name
    @profile_user = User.find_by(name: params[:name])
    if @profile_user == nil
      flash[:alert] = "Profile not found, Please try again!"
      redirect_to :feed
    end

    @like_user_in_each_post = []
    @profile_user.posts.each do |post|
      tmp1 = []
      post.likes.each do |like|
        tmp1.append(User.find(like.user_id).name)
      end
      @like_user_in_each_post.append(tmp1.join(","))
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
    follow_user = User.find(params[:user_id]) rescue nil
    if (follow_user != nil )
      #@user.following.push(follow_user.id)
      #@user.save

      # ===follow table===

      if (Follow.find_by(follower_id: session[:user_id], followee_id: follow_user.id) == nil) 
        new_follow = Follow.create(follower_id: session[:user_id], followee_id: follow_user.id)
        puts "------------create follow #{new_follow.follower_id} --> #{new_follow.followee_id}"
        flash[:success] = "Follow \"#{follow_user.name}\" Successfully!!"
        redirect_to :feed
      else 
        puts "------------create follow but there is duplicate follow"
        flash[:alert] = "You already follow this beloved user :D"
        redirect_to :feed
      end

      #==================

    else
      flash[:alert] = "There is no User in the system!!"
      redirect_to :feed
    end

  end

  def unfollow_by_id
    @user = User.find(session[:user_id])
    unfollow_user = User.find(params[:user_id]) rescue nil
    if (unfollow_user != nil)
      #@user.following.delete(unfollow_user.id)
      #@user.save

      # ===follow table===
      if (Follow.find_by(follower_id: session[:user_id], followee_id: unfollow_user.id) != nil)
        @follow = Follow.find_by(follower_id: session[:user_id], followee_id: unfollow_user.id)
        puts "------------delete follow #{@follow.follower_id} --> #{@follow.followee_id}"
        @follow.delete
        flash[:success] = "Unfollow \"#{unfollow_user.name}\" Successfully!!"
        redirect_to :feed
      else 
        puts "------------delete follow but there is no follow"
        flash[:alert] = "You are not following this user :D"
        redirect_to :feed
      end
      #===================

    else
      flash[:alert] = "There is no User in the system!!"
      redirect_to :feed
    end
  end

  def search_user
    if params[:name] == nil || params[:name].length == 0 
      flash[:alert] = "You did not enter the username, Please retry!!"
      redirect_to "/feed"
    elsif User.find_by(name: params[:name]) == nil
      flash[:alert] = "You enter wrong username, Please retry!!"
      redirect_to "/feed"
    else
      flash[:success] = "Congrats! We found your result!!"
      redirect_to "/profile/#{params[:name]}"
    end
      
  end
  def like_post

    to_follow_post = Post.find(params[:new_post_id])
    if (to_follow_post != nil )
      if (Like.find_by(user_id: session[:user_id], post_id: params[:new_post_id]) == nil) 
        new_like = Like.create(user_id: session[:user_id], post_id: params[:new_post_id])
        flash[:success] = "Like Successfully, You might like these posts too!!"
        redirect_to "/profile/#{User.find(to_follow_post.user_id).name}"
      else 
        flash[:alert] = "You already like this post :D"
        redirect_to :feed
      end
    else
      flash[:alert] = "There is no such Post in the system!!"
      redirect_to :feed
    end

  end

  def unlike_post
    to_del_like = Like.find(params[:like_id]) rescue nil
    if (to_del_like != nil)
      if (to_del_like.user_id == session[:user_id])
        to_del_like.delete
        flash[:success] = "Unlike Successfully!!"
        redirect_to :feed
      else 
        flash[:alert] = "You are not allowed to do this!!"
        redirect_to :feed
      end
    else
      flash[:alert] = "You have not like the post yet or the post is not exists!!"
      redirect_to :feed
    end
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
