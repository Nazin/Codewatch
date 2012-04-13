class UsersController < ApplicationController

  def index
  end
  
  def new
    @user = User.new
    user_companies = @user.user_companies.build
    user_companies.build_company
 
  end

  def create
    @user = User.new params[:user]
    if @user.save
      redirect_to @user
    else
      flash.now[:warning] =  "Invalid form input"
      render 'new'
    end
  end

  def show
    @user = User.find params[:id]
  end
 #   @companies = Company.all
 #   @user_company = @user.user_companies.build
    #TODO FILL
  #rescue ActiveRecord::StatementInvalid
    # Handle duplicate email addresses gracefully by redirecting.
  #  redirect_to root_path
  #rescue ActionController::InvalidAuthenticityToken
    # Experience has shown that the vast majority of these are bots
    # trying to spam the system, so catch & log the exception.
  
#  warning = "ActionController::InvalidAuthenticityToken: #{params.inspect}"
    #logger.warn warning
 
#   redirect_to root_path
#  end

  def show
    @user = User.find params[:id]
  end
  
  def edit
  end

  def update
  end

	def destroy
  end
	def signup
		
		if request.post?
			
			@user = User.new params[:signup][:user]
			@company = Company.new params[:signup][:company]
			
			 @user.valid?
			 @company.valid?
			
			if @user.valid? && @company.valid?
				
				#TODO: send mail
				#TODO: save models
			end
		else
			@user = User.new 
			@company = Company.new 
		end
	end

	def signin
	end
end
