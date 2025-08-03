class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update,:index,:destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end
  def index
    @users = User.paginate(page: params[:page])
    # ユーザー一覧をページネーションで取得
    # params[:page]はページ番号を指定するためのパラメータ
  end
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  def edit
    @user = User.find(params[:id])
  end
  def create
    @user = User.new(user_params)   
    if @user.save
      @user.send_activation_email # アカウント有効化メールを送信
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url 
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end
  # beforeフィルタ

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
