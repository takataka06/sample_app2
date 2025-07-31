class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update,:index,:destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy

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
  end
  def edit
    @user = User.find(params[:id])
  end
  def create
    @user = User.new(user_params)   
    if @user.save
      reset_session # ログインの直前に必ずこれを書くこと
      # ユーザーが保存された後にセッションをリセットする
      # これにより、セッションのIDが変更され、セキュリティが向上する
      log_in @user
      # 保存の成功をここで扱う。
      flash[:success] = "Welcome to the Sample App!" # メッセージを追加
      redirect_to @user # showアクションにリダイレクト
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

    # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location # リダイレクト前に現在のURLを保存
      flash[:danger] = "Please log in."
      redirect_to login_url, status: :see_other
    end
  end
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
