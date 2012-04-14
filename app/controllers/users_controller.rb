class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate page: params[:page]
  end
  
  def new
    @user = User.new
    user_companies = @user.user_companies.build
    user_companies.build_company
 
  end

  def create
    @user = User.new params[:user]
    if @user.save
      flash[:success] = "Welcome to Codewatch.pl!"
      sign_in @user
      redirect_to @user
    else
      flash.now[:warning] =  "Invalid informations"
      render 'new'
    end
  end

  def show
    @user = User.find params[:id]
  rescue ActiveRecord::StatementInvalid
    # Handle duplicate email addresses gracefully by redirecting.
    redirect_to root_path
  rescue ActionController::InvalidAuthenticityToken
    # Experience has shown that the vast majority of these are bots
    # trying to spam the system, so catch & log the exception.
    #warning = "ActionController::InvalidAuthenticityToken: #{params.inspect}"
    #logger.warn warning
    redirect_to root_path
  end

  def edit
  end

  def update
    if @user.update_attributes params[:user]
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      flash.now[:warning] =  "Invalid informations"
      render 'edit'
    end
  end

	def destroy
  end

private
  
  def signed_in_user
    store_location
    redirect_to signin_path, notice: "Please sign in"  unless signed_in?
  end

  def correct_user
    @user = User.find params[:id]
    redirect_to root_path unless current_user? @user
  end
end
