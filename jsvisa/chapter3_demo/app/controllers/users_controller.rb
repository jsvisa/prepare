class UsersController < ApplicationController

  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save 
      sign_in @user
      flash[:success] = "Welcome"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    # becase of we defined @user in method correct_user
    #@user = User.find(params[:id])
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    user = User.find(params[:id])
    if current_user?(user)
      flash[:error] = "Can't destroy admin user"
    else
      user.destroy
      flash[:success] = "User destroyed"
    end
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in." 
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

end
